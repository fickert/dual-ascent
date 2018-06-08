/*******************************************************************************
* Copyright (c) 2015, Maximilian Fickert, Andreas Karrenbauer
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
#pragma once

#include "graph.h"
#include "min_cost_flow_dual_ascent.h"

using RationalType = long long int;
using IntegerType = long long int;
using GraphType = Graph<IntegerType, RationalType>;

#ifdef RESTORE_BALANCED_NODES
using ArcDataType = DualAscentRBNArcData<RationalType>;
#else
using ArcDataType = BasicArcData<RationalType>;
#endif

class DefaultNodeIterator;
class DefaultEdgeIterator;

class DefaultNodeIterator {
public:
	DefaultNodeIterator() = delete;
	DefaultNodeIterator(const DefaultNodeIterator &) = default;

	DefaultNodeIterator(node v) : current_node(v) {}

	auto operator++() -> DefaultNodeIterator & {
		++current_node;
		return *this;
	}

	auto operator*() const -> node { return current_node; }

	auto operator==(const DefaultNodeIterator &other) const -> bool {
		return current_node == other.current_node;
	}

	auto operator!=(const DefaultNodeIterator &other) const -> bool {
		return !operator==(other);
	}

private:
	node current_node;
};

class DefaultEdgeIterator {
public:
	DefaultEdgeIterator() = delete;
	DefaultEdgeIterator(const DefaultEdgeIterator &) = default;

	DefaultEdgeIterator(arc a) : current_edge(a) {}

	auto operator++() -> DefaultEdgeIterator & {
		++current_edge;
		return *this;
	}

	auto operator*() const -> arc { return current_edge; }

	auto operator==(const DefaultEdgeIterator &other) const -> bool {
		return current_edge == other.current_edge;
	}

	auto operator!=(const DefaultEdgeIterator &other) const -> bool {
		return !operator==(other);
	}

private:
	arc current_edge;
};

template <typename NetworkType> class DefaultNodeAccessor {
public:
	DefaultNodeAccessor(NetworkType &N, const DefaultNodeIterator &node_it)
			: nodedata(N.nodedata[*node_it]) {}

	auto get_dual_objective_value_summand() const -> RationalType {
		return nodedata.demand * nodedata.potential;
	}

	auto get_potential() const -> RationalType { return nodedata.potential; }

	void set_potential(RationalType potential) {
		nodedata.potential = potential;
	}

	auto get_demand() const -> IntegerType { return nodedata.demand; }

	auto get_deficit() const -> IntegerType {
		return nodedata.demand - nodedata.net_inflow;
	}

	void set_deficit(IntegerType deficit) {
		nodedata.net_inflow = nodedata.demand - deficit;
	}

	auto get_depth() const -> int { return nodedata.depth; }

	void set_depth(int depth) { nodedata.depth = depth; }

	auto is_visited() const -> bool { return nodedata.visited; }

	void set_visited(bool visited) { nodedata.visited = visited; }

#ifdef RESTORE_BALANCED_NODES
	auto get_deficit_delta() const -> IntegerType {
		return nodedata.deficit_delta;
	}

	void set_deficit_delta(IntegerType deficit_delta) {
		nodedata.deficit_delta = deficit_delta;
	}
#endif

private:
	typename NetworkType::NodeDataType &nodedata;
};

template <typename NetworkType> class DefaultEdgeAccessor {
public:
	DefaultEdgeAccessor(NetworkType &N, const DefaultEdgeIterator &edge_it)
			: N(N), head(N.G.heads[std::abs(*edge_it)]),
			  tail(N.G.tails[std::abs(*edge_it)]),
			  arcdata(N.arcdata[std::abs(*edge_it)]) {}

	auto get_dual_objective_value_summand() const -> RationalType {
		return arcdata.capacity *
			   std::min(static_cast<RationalType>(0),
						arcdata.cost + N.nodedata[tail].potential -
								N.nodedata[head].potential);
	}

	auto get_head() const -> DefaultNodeIterator {
		return DefaultNodeIterator(head);
	}

	auto get_tail() const -> DefaultNodeIterator {
		return DefaultNodeIterator(tail);
	}

	auto increase_flow(RationalType amount) -> RationalType {
		auto delta =
				amount > 0 ? std::min(arcdata.capacity - arcdata.xlower, amount)
						   : -std::min(arcdata.xlower, -amount);
		arcdata.xlower += delta;
		return delta;
	}

	auto increase_flow_to_capacity() -> RationalType {
		assert(arcdata.xlower <= arcdata.capacity);
		auto flow_incr = arcdata.capacity - arcdata.xlower;
		arcdata.xlower = arcdata.capacity;
		return flow_incr;
	}

	auto can_increase_flow() const -> bool {
		return arcdata.xlower < arcdata.capacity;
	}

	auto can_decrease_flow() const -> bool { return arcdata.xlower > 0; }

	auto get_forward_cost() const -> RationalType { return arcdata.cost; }

	auto get_backward_cost() const -> RationalType {
		return -get_forward_cost();
	}

#ifdef RESTORE_BALANCED_NODES
	// TODO: why is the flow a rational type but deficit is integer type?
	auto get_flow_delta() const -> RationalType { return arcdata.flow_delta; }

	void set_flow_delta(RationalType flow_delta) {
		arcdata.flow_delta = flow_delta;
	}
#endif

#ifdef GREEDY_DUAL_ASCENT
	auto get_capacity() const -> IntegerType { return arcdata.capacity; }

	auto get_residual_capacity() const -> IntegerType {
		return arcdata.capacity - arcdata.xlower;
	}

	auto get_residual_backward_capacity() const -> IntegerType {
		return arcdata.xlower;
	}

	auto decrease_flow_to_zero() -> RationalType {
		assert(arcdata.xlower <= arcdata.capacity);
		auto flow_incr = -arcdata.xlower;
		arcdata.xlower = 0;
		return flow_incr;
	}
#endif

protected:
	NetworkType &N;
	node head;
	node tail;
	ArcDataType &arcdata;
};

template <typename NetworkType> class DefaultIncidentEdgesIterator {
public:
	DefaultIncidentEdgesIterator() = delete;
	DefaultIncidentEdgesIterator(const DefaultIncidentEdgesIterator &) =
			default;

	DefaultIncidentEdgesIterator(const NetworkType &N,
								 DefaultNodeIterator node_it)
			: N(N), v(*node_it), pos(0) {}
	DefaultIncidentEdgesIterator(const NetworkType &N,
								 DefaultNodeIterator node_it, size_t pos)
			: N(N), v(*node_it), pos(pos) {}

	auto operator++() -> DefaultIncidentEdgesIterator & {
		++pos;
		return *this;
	};

	auto operator*() const -> DefaultEdgeIterator {
		return DefaultEdgeIterator(std::abs(N.G.incident_edges[v][pos]));
	};

	auto operator==(const DefaultIncidentEdgesIterator &other) const -> bool {
		return v == other.v && pos == other.pos;
	}

	auto operator!=(const DefaultIncidentEdgesIterator &other) const -> bool {
		return !operator==(other);
	}

private:
	const NetworkType &N;
	const node v;
	size_t pos;
};

template <typename NetworkType>
auto get_number_of_nodes(const NetworkType &N) -> unsigned int {
	return N.G.no_of_vertices;
};

template <typename NetworkType>
auto begin_incident_edges(const NetworkType &N, const DefaultNodeIterator &node)
		-> DefaultIncidentEdgesIterator<NetworkType> {
	return DefaultIncidentEdgesIterator<NetworkType>(N, node);
};

template <typename NetworkType>
auto end_incident_edges(const NetworkType &N, const DefaultNodeIterator &node)
		-> DefaultIncidentEdgesIterator<NetworkType> {
	return DefaultIncidentEdgesIterator<NetworkType>(
			N, node, N.G.incident_edges[*node].size());
};

template <typename NetworkType>
#ifndef NDEBUG
void run_debug_checks(const NetworkType &N) {

#ifndef INFINITE_CAPACITY
#define INFINITE_CAPACITY                                                      \
	std::numeric_limits<decltype(N.arcdata.front().capacity)>::max()
#endif

	for (auto a = 1u; a < N.G.no_of_edges; ++a) {
		const auto &arcdata = N.arcdata[a];
		const auto &i = N.G.tails[a];
		const auto &j = N.G.heads[a];

		// check primal feasibility
		assert(arcdata.xlower <= arcdata.capacity &&
			   "capacity constraints check failed");

		// check dual feasibility
		assert((arcdata.capacity != INFINITE_CAPACITY ||
				arcdata.cost + N.nodedata[i].potential -
								N.nodedata[j].potential >=
						0) &&
			   "dual feasibility check failed");

		// check complementary slackness
		assert((arcdata.cost + N.nodedata[i].potential -
								N.nodedata[j].potential <=
						0 ||
				arcdata.xlower == 0) &&
			   "complementary slackness check 1 failed");
		assert((arcdata.cost + N.nodedata[i].potential -
								N.nodedata[j].potential >=
						0 ||
				arcdata.xlower == arcdata.capacity) &&
			   "complementary slackness check 2 failed");
		assert((!(arcdata.xlower > 0 && arcdata.xlower < arcdata.capacity) ||
				arcdata.cost + N.nodedata[i].potential -
								N.nodedata[j].potential ==
						0) &&
			   "complementary slackness check 3 failed");
	}
}
#else
void run_debug_checks(const NetworkType &) {
}
#endif
