/*******************************************************************************
* Copyright (c) 2015, Maximilian Fickert
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * The name of the author may not be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
* EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
* OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
* WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
* OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************/
#include "graph.h"
#include "min_cost_flow_dual_ascent.h"
#include "min_cost_flow_dual_ascent_default.h"

#ifdef SCALING
#include "min_cost_flow_dual_ascent_scaling.h"
#endif

#include <fstream>
#include <iostream>

#ifndef _WIN32
#include <sys/times.h>
#else
#include <boost/timer/timer.hpp>
#endif

int main(int argc, char *argv[]) {

	std::cout << "Enter filepath to input graph.. " << std::endl;
	std::string filename;
	std::cin >> filename;

	// check if file exists
	if (!std::ifstream(filename)) {
		std::cerr << "File not found: " << filename << std::endl;
		exit(1);
	}

	using RationalType = long long int;
	using IntegerType = long long int;

	Graph<IntegerType, RationalType> G(filename);
#ifdef RESTORE_BALANCED_NODES
	Network<decltype(G), IntegerType, RationalType,
			DualAscentNodeData<IntegerType, RationalType>,
			DualAscentRBNArcData<RationalType>>
			N(G, filename);
#else
	Network<decltype(G), IntegerType, RationalType,
			DualAscentNodeData<IntegerType, RationalType>,
			BasicArcData<RationalType>>
			N(G, filename);
#endif

	std::cout << "Number of Edges: " << N.G.no_of_edges << std::endl;
	std::cout << "Number of Nodes: " << N.G.no_of_vertices << std::endl;

	assert(argc <= 2);
	const auto RUNS = argc == 2 ? std::atoi(argv[1]) : 1;

	for (auto i = 0; i < RUNS; ++i) {
#ifndef _WIN32
		tms start_times;
		times(&start_times);
#else
		auto timer = boost::timer::cpu_timer();
#endif

#ifndef SCALING
		N.saturate_negative_cost_arcs();
#endif

		const auto nbegin = DefaultNodeIterator(1);
		const auto nend = DefaultNodeIterator(N.G.no_of_vertices + 1);
		const auto ebegin = DefaultEdgeIterator(1);
#if defined(SCALING) && defined(RUN_ONE_STEP_WITHOUT_SCALING)
		auto eend = DefaultEdgeIterator(N.G.no_of_edges + 1);
#else
		const auto eend = DefaultEdgeIterator(N.G.no_of_edges + 1);
#endif

#ifdef SCALING
		_PHASE = 8 * sizeof(RationalType) - 1;
		while (std::min(N.max_capacity, N.max_demand) >> _PHASE == 0)
			--_PHASE;
		auto num_steps = std::vector<int>();
		num_steps.reserve(_PHASE);

		do {
			std::cout << "phase " << _PHASE << std::endl;
			auto statistics =
					dual_ascent<decltype(N), DefaultNodeIterator,
								DefaultEdgeIterator,
								DemandScalingNodeAccessor<decltype(N)>,
								CapacityScalingArcAccessor<decltype(N)>,
								DefaultIncidentEdgesIterator<decltype(N)>>(
							N, nbegin, nend, ebegin, eend, _PHASE);
			num_steps.push_back(statistics.num_steps);
		} while (--_PHASE >= 0);
#else
		auto statistics =
				dual_ascent<decltype(N), DefaultNodeIterator,
							DefaultEdgeIterator,
							DefaultNodeAccessor<decltype(N)>,
							DefaultEdgeAccessor<decltype(N)>,
							DefaultIncidentEdgesIterator<decltype(N)>>(
						N, nbegin, nend, ebegin, eend);
		auto num_steps = statistics.num_steps;
#endif

#ifndef _WIN32
		tms end_times;
		times(&end_times);
		auto user_time = end_times.tms_utime + end_times.tms_cutime -
						 start_times.tms_utime - start_times.tms_cutime;
		auto system_time = end_times.tms_stime + end_times.tms_cstime -
						   start_times.tms_stime - start_times.tms_cstime;
		auto elapsed_time =
				((float)(user_time + system_time)) / sysconf(_SC_CLK_TCK);
		std::cout << "total time: " << std::fixed << std::setprecision(3)
				  << elapsed_time << "s" << std::endl;
#else
		auto time_string = boost::timer::format(timer.elapsed(), 3, "%t");
		std::cout << "total time: " << time_string << "s" << std::endl;
#endif

#ifdef SCALING
		std::cout << "number of steps:";
		for (auto num_steps_one_phase : num_steps)
			std::cout << " " << num_steps_one_phase;
		std::cout << std::endl;
#else
		std::cout << "number of steps: " << num_steps << std::endl;
#endif

		if (i != RUNS - 1)
			N.reset();
	}

	// check flow conservation
	for (auto v = 1u; v < N.G.no_of_vertices; ++v) {
		auto sum_v = static_cast<decltype(N.arcdata.front().xlower)>(0);
		for (auto edge : N.G.incident_edges[v]) {
			if (edge > 0) {
				sum_v -= N.arcdata[edge].xlower;
			} else {
				sum_v += N.arcdata[-edge].xlower;
			}
		}
		if (!(sum_v == N.nodedata[v].demand)) {
			std::cerr << "flow conservation check failed" << std::endl;
			exit(1);
		}
	}

	// check complementary slackness et al
	for (auto a = 1u; a < N.G.no_of_edges; ++a) {
		const auto &arcdata = N.arcdata[a];
		const auto &i = N.G.tails[a];
		const auto &j = N.G.heads[a];

		// check primal feasibility
		if (!(arcdata.xlower <= arcdata.capacity)) {
			std::cerr << "capacity constraints check failed" << std::endl;
			exit(1);
		}

#ifdef INFINITE_CAPACITY
		// check dual feasibility
		if (!(arcdata.capacity != INFINITE_CAPACITY ||
			  arcdata.cost + N.nodedata[i].potential -
							  N.nodedata[j].potential >=
					  0)) {
			std::cerr << "dual feasibility check failed" << std::endl;
			exit(1);
		}
#endif

		// check complementary slackness
		if (!(arcdata.cost + N.nodedata[i].potential -
							  N.nodedata[j].potential <=
					  0 ||
			  arcdata.xlower == 0)) {
			std::cerr << "complementary slackness check 1 failed" << std::endl;
			exit(1);
		}
		if (!(arcdata.cost + N.nodedata[i].potential -
							  N.nodedata[j].potential >=
					  0 ||
			  arcdata.xlower == arcdata.capacity)) {
			std::cerr << "complementary slackness check 2 failed" << std::endl;
			exit(1);
		}
		if (!(!(arcdata.xlower > 0 && arcdata.xlower < arcdata.capacity) ||
			  arcdata.cost + N.nodedata[i].potential -
							  N.nodedata[j].potential ==
					  0)) {
			std::cerr << "complementary slackness check 3 failed" << std::endl;
			exit(1);
		}
	}

	return 0;
}
