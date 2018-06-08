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
#pragma once

#include "min_cost_flow_dual_ascent.h"
#include "min_cost_flow_dual_ascent_default.h"

auto _PHASE = 0;

inline auto scale(const RationalType &x) -> RationalType {
	return x < 0 ? -(-x >> _PHASE << _PHASE) : x >> _PHASE << _PHASE;
}

template <typename NetworkType> class DemandScalingNodeAccessor {
public:
	DemandScalingNodeAccessor(NetworkType &N,
							  const DefaultNodeIterator &node_it)
			: nodedata(N.nodedata[*node_it]) {}

	auto get_dual_objective_value_summand() const -> RationalType {
		return nodedata.demand * nodedata.potential;
	}

	auto get_potential() const -> RationalType { return nodedata.potential; }

	void set_potential(RationalType potential) {
		nodedata.potential = potential;
	}

	auto get_demand() const -> IntegerType { return scale(nodedata.demand); }

	auto get_deficit() const -> IntegerType {
		return scale(nodedata.demand) - nodedata.net_inflow;
	}

	void set_deficit(IntegerType deficit) {
		nodedata.net_inflow = scale(nodedata.demand) - deficit;
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

template <typename NetworkType> class CapacityScalingArcAccessor {
public:
	CapacityScalingArcAccessor(NetworkType &N,
							   const DefaultEdgeIterator &arc_it)
			: N(N), head(N.G.heads[std::abs(*arc_it)]),
			  tail(N.G.tails[std::abs(*arc_it)]),
			  arcdata(N.arcdata[std::abs(*arc_it)]) {}

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

	auto increase_flow(const RationalType &amount) -> RationalType {
		auto delta =
				amount > 0 ? std::min(scale(arcdata.capacity) - arcdata.xlower,
									  amount)
						   : -std::min(arcdata.xlower, -amount);
		arcdata.xlower += delta;
		return delta;
	}

	auto increase_flow_to_capacity() -> RationalType {
		return increase_flow(arcdata.capacity);
	}

	auto can_increase_flow() const -> bool {
		return scale(arcdata.capacity) - arcdata.xlower > 0;
	}

	auto can_decrease_flow() const -> bool { return arcdata.xlower > 0; }

	auto get_forward_cost() const -> RationalType { return arcdata.cost; }

	auto get_backward_cost() const -> RationalType {
		return -get_forward_cost();
	}

#ifdef RESTORE_BALANCED_NODES
	auto get_flow_delta() const -> RationalType { return arcdata.flow_delta; }

	void set_flow_delta(RationalType flow_delta) {
		arcdata.flow_delta = flow_delta;
	}
#endif

#ifdef GREEDY_DUAL_ASCENT
	auto get_capacity() const -> IntegerType { return scale(arcdata.capacity); }

	auto get_residual_capacity() const -> IntegerType {
		return scale(arcdata.capacity) - arcdata.xlower;
	}

	auto get_residual_backward_capacity() const -> IntegerType {
		return arcdata.xlower;
	}

	auto decrease_flow_to_zero() -> RationalType {
		assert(arcdata.xlower <= scale(arcdata.capacity));
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
