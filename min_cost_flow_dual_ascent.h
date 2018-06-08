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

#include "hybrid_queue.h"
#include "min_cost_flow_dual_ascent_default.h"
#include "min_cost_flow_dual_ascent_queue.h"

#ifdef GREEDY_DUAL_ASCENT
#include "greedy_dual_ascent_queue.h"
#ifdef ALTERNATION_QUEUE
#include "greedy_dual_ascent_alternation_queue.h"
#endif
#endif

#include <queue>
#include <utility>
#include <vector>

#include <boost/range/adaptor/reversed.hpp>

/* illegal combinations of preprocessor directives */

#if START_NODE_SELECTION_METHOD == 2 && !defined(RESTORE_BALANCED_NODES)
static_assert(false, "If START_NODE_SELECTION_METHOD is set to 2, "
					 "RESTORE_BALANCED_NODES must be used.");
#endif

#if START_NODE_SELECTION_METHOD == 1 && defined(STOP_IF_DEFICIT_IS_ZERO)
static_assert(false, "If START_NODE_SELECTION_METHOD is set to 1, "
					 "STOP_IF_DEFICIT_IS_ZERO must not be used.");
#endif

#if START_NODE_SELECTION_METHOD == 1 && defined(STOP_IF_DEFICIT_SIGN_CHANGES)
static_assert(false, "If START_NODE_SELECTION_METHOD is set to 1, "
					 "STOP_IF_DEFICIT_SIGN_CHANGES must not be used.");
#endif

#if START_NODE_SELECTION_METHOD == 1 &&                                        \
		defined(STOP_IF_NODE_DEFICIT_SIGN_CHANGES)
static_assert(false, "If START_NODE_SELECTION_METHOD is set to 1, "
					 "STOP_IF_NODE_DEFICIT_SIGN_CHANGES must not be used.");
#endif

#if START_NODE_SELECTION_METHOD == 1 && defined(RESTORE_BALANCED_NODES)
static_assert(false, "If START_NODE_SELECTION_METHOD is set to 1, "
					 "RESTORE_BALANCED_NODES must not be used.");
#endif

#if defined(ONLY_IF_PREVIOUSLY_BALANCED) && !defined(RESTORE_BALANCED_NODES)
static_assert(false, "ONLY_IF_PREVIOUSLY_BALANCED can only be used in "
					 "conjunction with RESTORE_BALANCED_NODES.");
#endif

#if defined(GREEDY_DUAL_ASCENT) && defined(HYBRID_QUEUE)
static_assert(false, "GREEDY_DUAL_ASCENT is incompatible with HYBRID_QUEUE");
#endif

#if defined(GREEDY_DUAL_ASCENT) && defined(HYBRID_VECTOR_QUEUE)
static_assert(false,
			  "GREEDY_DUAL_ASCENT is incompatible with HYBRID_VECTOR_QUEUE");
#endif

#if START_NODE_SELECTION_METHOD == 2 && defined(GREEDY_DUAL_ASCENT)
static_assert(false, "If START_NODE_SELECTION_METHOD is set to 2, "
					 "GREEDY_DUAL_ASCENT must not be used.");
#endif

#if defined(ALTERNATION_QUEUE) && !defined(GREEDY_DUAL_ASCENT)
static_assert(false, "ALTERNATION_QUEUE can only be used in conjunction with "
					 "GREEDY_DUAL_ASCENT.");
#endif

#ifdef START_NODE_SELECTION_METHOD
static_assert(START_NODE_SELECTION_METHOD >= 0 &&
					  START_NODE_SELECTION_METHOD <= 3,
			  "START_NODE_SELECTION_METHOD must be one of:\n"
			  "    0 (choose the node with the most absolute deficit)\n"
			  "    1 (always choose the first node)\n"
			  "    2 (choose the one from last iteration, or the next "
			  "imbalanced node if the previous one is now balanced)\n"
			  "    3 (choose the one from last iteration, or the one with the "
			  "most absolute deficit if the previous one is now balanced)");
#endif

/* statistics */

struct dual_ascent_statistics {
	dual_ascent_statistics()
			:
#ifdef GREEDY_DUAL_ASCENT
			  num_arcs_with_reduced_cost_zero(0),
			  num_arcs_in_spanning_tree(0),
#endif
			  num_steps(0) {
	}

#ifdef GREEDY_DUAL_ASCENT
	long int num_arcs_with_reduced_cost_zero;
	long int num_arcs_in_spanning_tree;
#endif
	int num_steps;
};

/* generic functions */

template <typename Network, typename NodeIterator, typename NodeAccessor,
		  typename EdgeIterator, typename EdgeAccessor, typename NumberType>
auto compute_dual_objective_value(Network &N, const NodeIterator &nbegin,
								  const NodeIterator &nend,
								  const EdgeIterator &ebegin,
								  const EdgeIterator &eend) -> NumberType {
	auto dual_objective_value = static_cast<NumberType>(0);

	for (auto node_it = nbegin; node_it != nend; ++node_it) {
		const auto node_accessor = NodeAccessor(N, node_it);
		dual_objective_value +=
				node_accessor.get_dual_objective_value_summand();
	}

	for (auto edge_it = ebegin; edge_it != eend; ++edge_it) {
		const auto edge_accessor = EdgeAccessor(N, edge_it);
		dual_objective_value +=
				edge_accessor.get_dual_objective_value_summand();
	}

	return dual_objective_value;
}

template <typename Network, typename NodeIterator, typename NodeAccessor,
		  typename NumberType>
auto compute_demand_s(Network &N, const NodeIterator &nbegin,
					  const NodeIterator &nend) -> NumberType {
	auto demand_s = static_cast<NumberType>(0);

	for (auto node_it = nbegin; node_it != nend; ++node_it) {
		const auto node_accessor = NodeAccessor(N, node_it);
		if (node_accessor.is_visited())
			demand_s += node_accessor.get_demand();
	}

	return demand_s;
}

template <typename Network, typename NodeIterator, typename NodeAccessor>
auto get_node_with_most_absolute_deficit(Network &N, const NodeIterator &nbegin,
										 const NodeIterator &nend)
		-> NodeIterator {
	auto n = nend;
	auto deficit_n =
			static_cast<decltype(NodeAccessor(N, nbegin).get_deficit())>(0);

	for (auto node_it = nbegin; node_it != nend; ++node_it) {
		const auto node_accessor = NodeAccessor(N, node_it);
		const auto abs_deficit = std::abs(node_accessor.get_deficit());
		if (abs_deficit > deficit_n) {
			n = node_it;
			deficit_n = abs_deficit;
		}
	}

	return n;
}

template <typename Network, typename NodeIterator, typename NodeAccessor>
#if !defined(START_NODE_SELECTION_METHOD) || START_NODE_SELECTION_METHOD == 0
auto get_start_node(Network &N, const NodeIterator &nbegin,
					const NodeIterator &nend, const NodeIterator &)
		-> NodeIterator {
	// choose the one with the most absolute deficit
	return get_node_with_most_absolute_deficit<Network, NodeIterator,
											   NodeAccessor>(N, nbegin, nend);
#elif START_NODE_SELECTION_METHOD == 1
auto get_start_node(Network &, const NodeIterator &nbegin, const NodeIterator &,
					const NodeIterator &) -> NodeIterator {
	// always choose the first node
	return nbegin;
#elif START_NODE_SELECTION_METHOD == 2
auto get_start_node(Network &N, const NodeIterator &nbegin,
					const NodeIterator &nend, const NodeIterator &previous)
		-> NodeIterator {
// choose the one from last iteration, or the next imbalanced node if the
// previous one is now balanced
#ifndef NDEBUG
	if (previous != nend)
		for (auto node_it = nbegin; node_it != previous; ++node_it)
			assert(NodeAccessor(N, node_it).get_deficit() == 0);
#endif
	if (previous != nend && NodeAccessor(N, previous).get_deficit() != 0)
		return previous;
	auto next = previous;
	while (next != nend && NodeAccessor(N, next).get_deficit() == 0)
		++next;
	return next;
#else
auto get_start_node(Network &N, const NodeIterator &nbegin,
					const NodeIterator &nend, const NodeIterator &previous)
		-> NodeIterator {
	// choose the one from last iteration, or the one with the most absolute
	// deficit if the previous one is now balanced
	if (previous != nend && NodeAccessor(N, previous).get_deficit() != 0)
		return previous;
	return get_node_with_most_absolute_deficit<Network, NodeIterator,
											   NodeAccessor>(N, nbegin, nend);
#endif
}

template <typename Network, typename NodeIterator, typename NodeAccessor,
		  typename EdgeAccessor, typename IncidentEdgesIterator,
		  typename QueueType,
#if defined(STOP_IF_DEFICIT_CHANGES_SIGN) ||                                   \
		defined(STOP_IF_NODE_DEFICIT_CHANGES_SIGN)
		  typename PotentialType, typename DeficitType>
void update_s_in_s_out(Network &N, const NodeIterator &v, QueueType &queue,
					   PotentialType last_delta, DeficitType deficit_s) {
#else
		  typename PotentialType>
void update_s_in_s_out(Network &N, const NodeIterator &v, QueueType &queue,
					   PotentialType last_delta) {
#endif
	// std::cout << "added node: " << *v << std::endl;
	for (auto incident_edge_it = begin_incident_edges(N, v);
		 incident_edge_it != end_incident_edges(N, v); ++incident_edge_it) {
		auto edge = *incident_edge_it;
		auto edge_accessor = EdgeAccessor(N, edge);
		bool is_outgoing = edge_accessor.get_tail() == v;
		auto w = is_outgoing ? edge_accessor.get_head()
							 : edge_accessor.get_tail();

		auto v_accessor = NodeAccessor(N, v);
		auto w_accessor = NodeAccessor(N, w);

		auto potential_v = v_accessor.get_potential();
		auto potential_w = w_accessor.get_potential();

		if (w_accessor.is_visited())
			continue;

		if (is_outgoing) {
#if defined(GREEDY_DUAL_ASCENT) && !defined(RESIDUAL) &&                       \
		defined(ALTERNATION_QUEUE)
			if (queue.gda()) {
				auto key = edge_accessor.get_forward_cost() + potential_v -
						   potential_w;
				queue.push({key, edge}, true);
			} else {
#endif
#if defined(GREEDY_DUAL_ASCENT) && !defined(RESIDUAL) &&                       \
		!defined(ALTERNATION_QUEUE)
				auto key = edge_accessor.get_forward_cost() + potential_v -
						   potential_w;
				queue.push({key, edge}, true);
#else
#if defined(STOP_IF_DEFICIT_CHANGES_SIGN) ||                                   \
		defined(STOP_IF_NODE_DEFICIT_CHANGES_SIGN)
			if (deficit_s < 0 && edge_accessor.can_increase_flow()) {
#else
			if (edge_accessor.can_increase_flow()) {
#endif
				auto key = edge_accessor.get_forward_cost() + potential_v -
						   potential_w;
				assert(key - last_delta >= 0);
				queue.push({key, edge}, true);
			}
#if defined(STOP_IF_DEFICIT_CHANGES_SIGN) ||                                   \
		defined(STOP_IF_NODE_DEFICIT_CHANGES_SIGN)
			if (deficit_s > 0 && edge_accessor.can_decrease_flow()) {
#else
			if (edge_accessor.can_decrease_flow()) {
#endif
				auto key = edge_accessor.get_backward_cost() + potential_w -
						   potential_v;
				assert(key + last_delta >= 0);
				queue.push({key, edge}, false);
			}
#endif
#if defined(GREEDY_DUAL_ASCENT) && !defined(RESIDUAL) &&                       \
		defined(ALTERNATION_QUEUE)
			}
#endif
		} else {
#if defined(GREEDY_DUAL_ASCENT) && !defined(RESIDUAL) &&                       \
		defined(ALTERNATION_QUEUE)
			if (queue.gda()) {
				auto key = -(edge_accessor.get_forward_cost() + potential_w -
							 potential_v);
				queue.push({key, edge}, false);
			} else {
#endif
#if defined(GREEDY_DUAL_ASCENT) && !defined(RESIDUAL) &&                       \
		!defined(ALTERNATION_QUEUE)
				auto key = -(edge_accessor.get_forward_cost() + potential_w -
							 potential_v);
				queue.push({key, edge}, false);
#else
#if defined(STOP_IF_DEFICIT_CHANGES_SIGN) ||                                   \
		defined(STOP_IF_NODE_DEFICIT_CHANGES_SIGN)
			if (deficit_s > 0 && edge_accessor.can_increase_flow()) {
#else
			if (edge_accessor.can_increase_flow()) {
#endif
				auto key = edge_accessor.get_forward_cost() + potential_w -
						   potential_v;
				assert(key + last_delta >= 0);
				queue.push({key, edge}, false);
			}
#if defined(STOP_IF_DEFICIT_CHANGES_SIGN) ||                                   \
		defined(STOP_IF_NODE_DEFICIT_CHANGES_SIGN)
			if (deficit_s < 0 && edge_accessor.can_decrease_flow()) {
#else
			if (edge_accessor.can_decrease_flow()) {
#endif
				auto key = edge_accessor.get_backward_cost() + potential_v -
						   potential_w;
				assert(key - last_delta >= 0);
				queue.push({key, edge}, true);
			}
#endif
#if defined(GREEDY_DUAL_ASCENT) && !defined(RESIDUAL) &&                       \
		defined(ALTERNATION_QUEUE)
			}
#endif
		}
	}
}

template <typename Network, typename NodeIterator, typename NodeAccessor,
		  typename EdgeAccessor, typename IncidentEdgesIterator,
		  typename DeficitType, typename QueueType, typename TreeType>
auto explore_node(Network &N, const NodeIterator &nend,
				  typename QueueType::value_type top_element, QueueType &queue,
				  TreeType &tree) -> NodeIterator {
	auto delta = top_element.first;
	auto a_hat = top_element.second;

	auto edge_accessor = EdgeAccessor(N, a_hat);

	auto v = edge_accessor.get_tail();
	auto w = edge_accessor.get_head();

	auto v_accessor = NodeAccessor(N, v);
	auto w_accessor = NodeAccessor(N, w);

	if (v_accessor.is_visited() && w_accessor.is_visited())
		return nend;

	auto &new_node = v_accessor.is_visited() ? w : v;

	auto &old_accessor = v_accessor.is_visited() ? v_accessor : w_accessor;
	auto &new_accessor = v_accessor.is_visited() ? w_accessor : v_accessor;

	auto depth = old_accessor.get_depth() + 1;
	new_accessor.set_depth(depth);
	new_accessor.set_visited(true);
	new_accessor.set_potential(new_accessor.get_potential() + delta);

	if (tree.size() < static_cast<decltype(tree.size())>(depth))
		tree.resize(tree.size() + 1);
	tree[depth - 1].push_back({new_node, a_hat});

	assert(edge_accessor.get_forward_cost() + v_accessor.get_potential() -
						   w_accessor.get_potential() ==
				   0 ||
		   edge_accessor.get_backward_cost() + w_accessor.get_potential() -
						   v_accessor.get_potential() ==
				   0);

	update_s_in_s_out<Network, NodeIterator, NodeAccessor, EdgeAccessor,
					  IncidentEdgesIterator, QueueType,
					  decltype(v_accessor.get_potential())>(N, new_node, queue,
															delta);

	return new_node;
}

template <typename Network, typename EdgeIterator, typename NodeAccessor,
		  typename EdgeAccessor>
void update_x_by_slack(Network &N, const EdgeIterator &ebegin,
					   const EdgeIterator &eend,
					   dual_ascent_statistics &statistics) {
	for (auto edge_it = ebegin; edge_it != eend; ++edge_it) {
		auto edge_accessor = EdgeAccessor(N, edge_it);
		auto v_accessor = NodeAccessor(N, edge_accessor.get_tail());
		auto w_accessor = NodeAccessor(N, edge_accessor.get_head());
		const auto reduced_cost = edge_accessor.get_forward_cost() +
								  v_accessor.get_potential() -
								  w_accessor.get_potential();

		if (reduced_cost < 0) {
			const auto flow_incr = edge_accessor.increase_flow_to_capacity();
			v_accessor.set_deficit(v_accessor.get_deficit() + flow_incr);
			w_accessor.set_deficit(w_accessor.get_deficit() - flow_incr);
		} else if (reduced_cost > 0) {
			const auto flow_incr = edge_accessor.decrease_flow_to_zero();
			v_accessor.set_deficit(v_accessor.get_deficit() + flow_incr);
			w_accessor.set_deficit(w_accessor.get_deficit() - flow_incr);
		} else {
#ifdef GREEDY_DUAL_ASCENT
			++statistics.num_arcs_with_reduced_cost_zero;
#endif
			auto flow_incr = std::min(-v_accessor.get_deficit(),
									  w_accessor.get_deficit());
			flow_incr = edge_accessor.increase_flow(flow_incr);
			assert(std::abs(v_accessor.get_deficit()) +
						   std::abs(w_accessor.get_deficit()) >=
				   std::abs(v_accessor.get_deficit() + flow_incr) +
						   std::abs(w_accessor.get_deficit() - flow_incr));
			v_accessor.set_deficit(v_accessor.get_deficit() + flow_incr);
			w_accessor.set_deficit(w_accessor.get_deficit() - flow_incr);
		}
	}
}

#ifdef RESTORE_BALANCED_NODES
template <typename Network, typename NodeIterator, typename NodeAccessor,
		  typename EdgeAccessor, typename TreeType>
void update_x_by_tree(Network &N, const TreeType &tree,
					  const NodeIterator &nbegin, const NodeIterator &nend) {
	for (auto node_it = nbegin; node_it != nend; ++node_it) {
		auto node_accessor = NodeAccessor(N, node_it);
		node_accessor.set_deficit_delta(0);
	}
#else
template <typename Network, typename NodeAccessor, typename EdgeAccessor,
		  typename TreeType>
void update_x_by_tree(Network &N, const TreeType &tree) {
#endif
	for (const auto &depth : boost::adaptors::reverse(tree)) {
		for (const auto &tree_node : depth) {
// the node v has been explored over the edge a
#ifndef NDEBUG
			auto v = tree_node.first;
#endif
			auto a = tree_node.second;

			auto edge_accessor = EdgeAccessor(N, a);

			assert(((edge_accessor.get_head() == v) !=
					(edge_accessor.get_tail() == v)) &&
				   "the node must be either the edge's head or its tail");

			auto i = edge_accessor.get_tail();
			auto j = edge_accessor.get_head();

			auto i_accessor = NodeAccessor(N, i);
			auto j_accessor = NodeAccessor(N, j);

			assert(edge_accessor.get_forward_cost() +
						   i_accessor.get_potential() -
						   j_accessor.get_potential() ==
				   0);

			auto flow_incr = i_accessor.get_depth() > j_accessor.get_depth()
									 ? -i_accessor.get_deficit()
									 : j_accessor.get_deficit();

			// only update edges with slack 0
			if (!((flow_incr < 0 &&
				   edge_accessor.get_backward_cost() +
								   j_accessor.get_potential() -
								   i_accessor.get_potential() ==
						   0) ||
				  (flow_incr > 0 &&
				   edge_accessor.get_forward_cost() +
								   i_accessor.get_potential() -
								   j_accessor.get_potential() ==
						   0))) {
#ifdef RESTORE_BALANCED_NODES
				edge_accessor.set_flow_delta(0);
#endif
				continue;
			}

			flow_incr = edge_accessor.increase_flow(flow_incr);

			i_accessor.set_deficit(i_accessor.get_deficit() + flow_incr);
			j_accessor.set_deficit(j_accessor.get_deficit() - flow_incr);

#ifdef RESTORE_BALANCED_NODES
			edge_accessor.set_flow_delta(flow_incr);
			i_accessor.set_deficit_delta(i_accessor.get_deficit_delta() +
										 flow_incr);
			j_accessor.set_deficit_delta(j_accessor.get_deficit_delta() -
										 flow_incr);
#endif
		}
	}

#ifdef RESTORE_BALANCED_NODES

	for (const auto &depth : tree) {
		for (const auto &tree_node : depth) {
			auto a = tree_node.second;
			auto edge_accessor = EdgeAccessor(N, a);

			auto i = edge_accessor.get_tail();
			auto j = edge_accessor.get_head();

			auto i_accessor = NodeAccessor(N, i);
			auto j_accessor = NodeAccessor(N, j);

			using DeficitType = decltype(i_accessor.get_deficit());

			if (i_accessor.get_depth() > j_accessor.get_depth()) {
				// i is the child node and j the parent node

				auto current_deficit = j_accessor.get_deficit();
				auto previous_deficit =
						current_deficit - j_accessor.get_deficit_delta();

#ifdef ONLY_IF_PREVIOUSLY_BALANCED
				if (!(previous_deficit == 0 && current_deficit != 0))
					continue;

				auto target_deficit = 0;
#else
				auto target_deficit =
						previous_deficit < 0
								? std::min(static_cast<DeficitType>(0),
										   std::max(previous_deficit,
													current_deficit))
								: std::max(static_cast<DeficitType>(0),
										   std::min(previous_deficit,
													current_deficit));
#endif

				assert(std::abs(target_deficit) <= std::abs(previous_deficit));
				assert(std::abs(target_deficit) <= std::abs(current_deficit));

				if (current_deficit == target_deficit)
					// nothing changed
					continue;

				auto flow_incr = -(target_deficit - current_deficit);

				if (!((flow_incr > 0 && edge_accessor.get_flow_delta() < 0) ||
					  (flow_incr < 0 && edge_accessor.get_flow_delta() > 0)))
					// flow was updated in the other direction
					continue;

				flow_incr = flow_incr > 0
									? std::min(flow_incr,
											   -edge_accessor.get_flow_delta())
									: std::max(flow_incr,
											   -edge_accessor.get_flow_delta());

#ifndef NDEBUG
				auto actual_flow_incr = edge_accessor.increase_flow(flow_incr);
				assert(actual_flow_incr == flow_incr);
#else
				edge_accessor.increase_flow(flow_incr);
#endif

				i_accessor.set_deficit(i_accessor.get_deficit() + flow_incr);
				i_accessor.set_deficit_delta(i_accessor.get_deficit_delta() +
											 flow_incr);
				j_accessor.set_deficit(j_accessor.get_deficit() - flow_incr);
				j_accessor.set_deficit_delta(j_accessor.get_deficit_delta() -
											 flow_incr);

				assert(std::abs(j_accessor.get_deficit()) <=
					   std::abs(current_deficit));
			} else {
				// j is the child node and i the parent node

				auto current_deficit = i_accessor.get_deficit();
				auto previous_deficit =
						current_deficit - i_accessor.get_deficit_delta();

#ifdef ONLY_IF_PREVIOUSLY_BALANCED
				if (!(previous_deficit == 0 && current_deficit != 0))
					continue;

				auto target_deficit = 0;
#else
				auto target_deficit =
						previous_deficit < 0
								? std::min(static_cast<DeficitType>(0),
										   std::max(previous_deficit,
													current_deficit))
								: std::max(static_cast<DeficitType>(0),
										   std::min(previous_deficit,
													current_deficit));
#endif

				assert(std::abs(target_deficit) <= std::abs(previous_deficit));
				assert(std::abs(target_deficit) <= std::abs(current_deficit));

				if (current_deficit == target_deficit)
					// nothing changed
					continue;

				auto flow_incr = target_deficit - current_deficit;

				if (!((flow_incr > 0 && edge_accessor.get_flow_delta() < 0) ||
					  (flow_incr < 0 && edge_accessor.get_flow_delta() > 0)))
					// flow was updated in the other direction
					continue;

				flow_incr = flow_incr > 0
									? std::min(flow_incr,
											   -edge_accessor.get_flow_delta())
									: std::max(flow_incr,
											   -edge_accessor.get_flow_delta());

#ifndef NDEBUG
				auto actual_flow_incr = edge_accessor.increase_flow(flow_incr);
				assert(actual_flow_incr == flow_incr);
#else
				edge_accessor.increase_flow(flow_incr);
#endif

				i_accessor.set_deficit(i_accessor.get_deficit() + flow_incr);
				i_accessor.set_deficit_delta(i_accessor.get_deficit_delta() +
											 flow_incr);
				j_accessor.set_deficit(j_accessor.get_deficit() - flow_incr);
				j_accessor.set_deficit_delta(j_accessor.get_deficit_delta() -
											 flow_incr);

				assert(std::abs(i_accessor.get_deficit()) <=
					   std::abs(current_deficit));
			}
		}
	}

#ifndef NDEBUG
	for (const auto &depth : tree) {
		for (const auto &tree_node : depth) {
			auto a = tree_node.second;
			auto edge_accessor = EdgeAccessor(N, a);

			auto i = edge_accessor.get_tail();
			auto j = edge_accessor.get_head();

			auto i_accessor = NodeAccessor(N, i);
			auto j_accessor = NodeAccessor(N, j);

			auto old_deficit = i_accessor.get_depth() > j_accessor.get_depth()
									   ? j_accessor.get_deficit() -
												 j_accessor.get_deficit_delta()
									   : i_accessor.get_deficit() -
												 i_accessor.get_deficit_delta();
			auto new_deficit = i_accessor.get_depth() > j_accessor.get_depth()
									   ? j_accessor.get_deficit()
									   : i_accessor.get_deficit();

			assert(old_deficit > 0 ||
				   (new_deficit <= 0 && new_deficit >= old_deficit));
			assert(old_deficit < 0 ||
				   (new_deficit >= 0 && new_deficit <= old_deficit));
		}
	}
#endif
#endif
}

template <typename Network, typename NodeIterator, typename NodeAccessor,
		  typename DeficitType>
auto compute_deficit_1(Network &N, const NodeIterator &nbegin,
					   const NodeIterator &nend) -> DeficitType {
	auto deficit_1 = static_cast<DeficitType>(0);

	for (auto node_it = nbegin; node_it != nend; ++node_it) {
		auto node_accessor = NodeAccessor(N, node_it);
		deficit_1 += std::abs(node_accessor.get_deficit());
	}

	return deficit_1;
}

template <typename Network, typename NodeIterator, typename NodeAccessor,
		  typename EdgeAccessor, typename IncidentEdgesIterator,
		  typename DeficitType, typename QueueType
#ifndef GREEDY_DUAL_ASCENT
		  >
auto build_initial_s(Network &N, const NodeIterator &nbegin,
					 const NodeIterator &nend, NodeIterator &start_node,
					 QueueType &queue, bool is_first_iteration)
		-> std::tuple<unsigned int, DeficitType> {
#else
		  >
auto build_initial_s(Network &N, const NodeIterator &nbegin,
					 const NodeIterator &nend, NodeIterator &start_node,
					 QueueType &queue, bool is_first_iteration)
		-> std::tuple<unsigned int, DeficitType, DeficitType> {
#endif
	start_node = get_start_node<Network, NodeIterator, NodeAccessor>(
			N, nbegin, nend, start_node);

#if START_NODE_SELECTION_METHOD == 1
	if (compute_deficit_1<Network, NodeIterator, NodeAccessor, DeficitType>(
				N, nbegin, nend) == 0 &&
		!is_first_iteration)
#ifndef GREEDY_DUAL_ASCENT
		return make_tuple(0, 0);
#else
		return make_tuple(0, 0, 0);
#endif
#else
	if (start_node == nend) {
		if (is_first_iteration) {
			start_node = nbegin;
		} else {
#ifndef GREEDY_DUAL_ASCENT
			return make_tuple(0, 0);
#else
			return make_tuple(0, 0, 0);
#endif
		}
	}
#endif

	auto start_node_accessor = NodeAccessor(N, start_node);
	start_node_accessor.set_visited(true);
	start_node_accessor.set_depth(0);

	update_s_in_s_out<Network, NodeIterator, NodeAccessor, EdgeAccessor,
					  IncidentEdgesIterator, QueueType,
					  decltype(start_node_accessor.get_potential())>(
			N, start_node, queue, 0);

#ifndef GREEDY_DUAL_ASCENT
	return make_tuple(1, start_node_accessor.get_deficit());
#else
	return make_tuple(1, start_node_accessor.get_deficit(),
					  start_node_accessor.get_demand());
#endif
}

template <typename Network, typename NodeIterator, typename NodeAccessor>
void reset_data(Network &N, const NodeIterator &nbegin,
				const NodeIterator &nend) {
	for (auto node_it = nbegin; node_it != nend; ++node_it) {
		auto node_accessor = NodeAccessor(N, node_it);
		node_accessor.set_visited(false);
		node_accessor.set_depth(-1);
	}
}

template <typename Network, typename NodeIterator, typename EdgeIterator,
		  typename NodeAccessor, typename EdgeAccessor,
		  typename IncidentEdgesIterator>
#ifdef SCALING
auto dual_ascent(Network &N, const NodeIterator &nbegin,
				 const NodeIterator &nend, const EdgeIterator &ebegin,
				 const EdgeIterator &eend, const int phase)
		-> dual_ascent_statistics {
#else
auto dual_ascent(Network &N, const NodeIterator &nbegin,
				 const NodeIterator &nend, const EdgeIterator &ebegin,
				 const EdgeIterator &eend) -> dual_ascent_statistics {
#endif

#if (defined(STOP_IF_DEFICIT_IS_ZERO) ||                                       \
	 defined(STOP_IF_DEFICIT_SIGN_CHANGES) ||                                  \
	 defined(STOP_IF_NODE_DEFICIT_SIGN_CHANGES)) &&                            \
		!defined(EXPLORE_ENTIRE_GRAPH_EVERY_X_ITERATIONS)
#define EXPLORE_ENTIRE_GRAPH_EVERY_X_ITERATIONS                                \
	std::numeric_limits<unsigned int>::max()
#endif

	using PotentialType = decltype(NodeAccessor(N, nbegin).get_potential());
	using DeficitType = decltype(NodeAccessor(N, nbegin).get_deficit());

	auto statistics = dual_ascent_statistics();

	auto &step_count = statistics.num_steps;
	auto start_node = nend;

#ifdef SCALING
	for (auto edge_it = ebegin; edge_it != eend; ++edge_it) {
		auto edge_accessor = EdgeAccessor(N, edge_it);
		auto v_accessor = NodeAccessor(N, edge_accessor.get_tail());
		auto w_accessor = NodeAccessor(N, edge_accessor.get_head());
		const auto reduced_cost = edge_accessor.get_forward_cost() +
								  v_accessor.get_potential() -
								  w_accessor.get_potential();

		if (reduced_cost < 0) {
			const auto flow_incr = edge_accessor.increase_flow_to_capacity();
			v_accessor.set_deficit(v_accessor.get_deficit() + flow_incr);
			w_accessor.set_deficit(w_accessor.get_deficit() - flow_incr);
		}
	}
#endif

#if !defined(NDEBUG) && !defined(SCALING)
	auto last_dual_objective_value =
			compute_dual_objective_value<Network, NodeIterator, NodeAccessor,
										 EdgeIterator, EdgeAccessor,
										 PotentialType>(N, nbegin, nend, ebegin,
														eend);
#endif

#ifdef SCALING
	auto last_deficit_1 =
			compute_deficit_1<Network, NodeIterator, NodeAccessor, DeficitType>(
					N, nbegin, nend);
#endif

	do {
#if !defined(NDEBUG) && !defined(SCALING)
		run_debug_checks(N);
#endif

		using PriorityQueueElementType = std::pair<PotentialType, EdgeIterator>;

#ifdef GREEDY_DUAL_ASCENT
#ifdef ALTERNATION_QUEUE
		auto compare_first = [](const PriorityQueueElementType &lhs,
								const PriorityQueueElementType &rhs) {
			if (lhs.first == rhs.first)
				return *lhs.second > *rhs.second;
			return lhs.first > rhs.first;
		};
		using NonGDAQueueInternalQueueType =
				std::priority_queue<PriorityQueueElementType,
									std::vector<PriorityQueueElementType>,
									decltype(compare_first)>;
#ifdef SCALING
		auto non_gda_queue = DualAscentQueue<NonGDAQueueInternalQueueType>(
				NonGDAQueueInternalQueueType(compare_first),
				NonGDAQueueInternalQueueType(compare_first), phase);
		auto gda_queue =
				greedy_dual_ascent_queue<PriorityQueueElementType, Network>(
						N, phase);
#else
		auto non_gda_queue = DualAscentQueue<NonGDAQueueInternalQueueType>(
				NonGDAQueueInternalQueueType(compare_first),
				NonGDAQueueInternalQueueType(compare_first));
		auto gda_queue =
				greedy_dual_ascent_queue<PriorityQueueElementType, Network>(N);
#endif
		auto queue = GDAAlternationQueue<decltype(gda_queue),
										 decltype(non_gda_queue)>(
				std::move(gda_queue), std::move(non_gda_queue),
				step_count % 2 == 1);
#else
#ifdef SCALING
		auto queue =
				greedy_dual_ascent_queue<PriorityQueueElementType, Network>(
						N, phase);
#else
		auto queue =
				greedy_dual_ascent_queue<PriorityQueueElementType, Network>(N);
#endif
#endif
#else
#if defined(USE_HYBRID_QUEUE) || defined(USE_HYBRID_VECTOR_QUEUE)
#ifdef USE_HYBRID_QUEUE
		using InternalQueueType = hybrid_queue<PotentialType, EdgeIterator>;
#else
		using InternalQueueType =
				hybrid_vector_queue<PotentialType, EdgeIterator>;
#endif
#ifdef SCALING
		auto queue = DualAscentQueue<InternalQueueType>(
				InternalQueueType(), InternalQueueType(), phase);
#else
		auto queue = DualAscentQueue<InternalQueueType>(InternalQueueType(),
														InternalQueueType());
#endif
#else

		auto compare_first = [](const PriorityQueueElementType &lhs,
								const PriorityQueueElementType &rhs) {
			if (lhs.first == rhs.first)
				return *lhs.second > *rhs.second;
			return lhs.first > rhs.first;
		};

		using InternalQueueType =
				std::priority_queue<PriorityQueueElementType,
									std::vector<PriorityQueueElementType>,
									decltype(compare_first)>;

		auto internal_queue_vector1 = std::vector<PriorityQueueElementType>();
		auto internal_queue_vector2 = std::vector<PriorityQueueElementType>();
		internal_queue_vector1.reserve(N.G.no_of_edges);
		internal_queue_vector2.reserve(N.G.no_of_edges);
#ifdef SCALING
		auto queue = DualAscentQueue<InternalQueueType>(
				InternalQueueType(compare_first,
								  std::move(internal_queue_vector1)),
				InternalQueueType(compare_first,
								  std::move(internal_queue_vector2)),
				phase);
#else
		auto queue = DualAscentQueue<InternalQueueType>(
				InternalQueueType(compare_first,
								  std::move(internal_queue_vector1)),
				InternalQueueType(compare_first,
								  std::move(internal_queue_vector2)));
#endif
#endif
#endif

		auto tree = std::vector<
				std::vector<std::pair<NodeIterator, EdgeIterator>>>();

		reset_data<Network, NodeIterator, NodeAccessor>(N, nbegin, nend);

#ifndef NDEBUG
		std::cout << "starting step " << step_count + 1;
#ifdef SCALING
		std::cout << ", deficit_1 = "
				  << (compute_deficit_1<Network, NodeIterator, NodeAccessor,
										DeficitType>(N, nbegin, nend) >>
					  phase);
#else
		std::cout << ", deficit_1 = "
				  << compute_deficit_1<Network, NodeIterator, NodeAccessor,
									   DeficitType>(N, nbegin, nend);
#endif
		const auto new_dual_objective_value =
				compute_dual_objective_value<Network, NodeIterator,
											 NodeAccessor, EdgeIterator,
											 EdgeAccessor, PotentialType>(
						N, nbegin, nend, ebegin, eend);
		std::cout << ", dual objective value = " << new_dual_objective_value
				  << std::endl;
#ifndef SCALING
		assert(last_dual_objective_value <= new_dual_objective_value);
		last_dual_objective_value = new_dual_objective_value;
#endif
#endif

		unsigned int num_visited;
		DeficitType deficit_s = 0;
#ifdef GREEDY_DUAL_ASCENT
		DeficitType demand_s = 0;
		std::tie(num_visited, deficit_s, demand_s) =
				build_initial_s<Network, NodeIterator, NodeAccessor,
								EdgeAccessor, IncidentEdgesIterator,
								DeficitType, decltype(queue)>(
						N, nbegin, nend, start_node, queue, step_count == 0u);
#else
		std::tie(num_visited, deficit_s) =
				build_initial_s<Network, NodeIterator, NodeAccessor,
								EdgeAccessor, IncidentEdgesIterator,
								DeficitType, decltype(queue)>(
						N, nbegin, nend, start_node, queue, step_count == 0u);
#endif
		if (num_visited == 0)
			break;

		++step_count;

#ifdef STOP_IF_NODE_DEFICIT_SIGN_CHANGES
		const auto v_start_deficit = deficit_s;
#endif

		while (num_visited < get_number_of_nodes(N) && !queue.empty()) {

#ifdef GREEDY_DUAL_ASCENT
			auto top = queue.pop(deficit_s, demand_s);
#else
			auto pop_top = [](
					decltype(queue) &queue,
					const DeficitType &deficit_s) -> PriorityQueueElementType {
				auto top = queue.top(deficit_s);
				queue.pop(deficit_s);
				return top;
			};

			auto top = pop_top(queue, deficit_s);
#endif

#if defined(STOP_IF_DEFICIT_IS_ZERO) ||                                        \
		defined(STOP_IF_DEFICIT_SIGN_CHANGES) ||                               \
		defined(STOP_IF_NODE_DEFICIT_SIGN_CHANGES)
			auto delta = top.first;
#endif

			auto new_node =
					explore_node<Network, NodeIterator, NodeAccessor,
								 EdgeAccessor, IncidentEdgesIterator,
								 DeficitType, decltype(queue), decltype(tree)>(
							N, nend, top, queue, tree);

#ifdef GREEDY_DUAL_ASCENT
#ifdef ALTERNATION_QUEUE
			assert(!queue.gda() || new_node != nend);
#else
			assert(new_node != nend);
#endif
#endif

			if (new_node != nend) {
				auto node_accessor = NodeAccessor(N, new_node);
#ifdef STOP_IF_DEFICIT_SIGN_CHANGES
				auto previous_deficit_s = deficit_s;
#endif
				deficit_s += node_accessor.get_deficit();
#ifdef GREEDY_DUAL_ASCENT
				demand_s += node_accessor.get_demand();
				++statistics.num_arcs_in_spanning_tree;
#endif

				++num_visited;

#if defined(STOP_IF_DEFICIT_IS_ZERO) ||                                        \
		defined(STOP_IF_DEFICIT_SIGN_CHANGES) ||                               \
		defined(STOP_IF_NODE_DEFICIT_SIGN_CHANGES)
				if (step_count % EXPLORE_ENTIRE_GRAPH_EVERY_X_ITERATIONS != 0) {
#ifdef STOP_IF_DEFICIT_IS_ZERO
					if (step_count > 1 &&
						deficit_s == static_cast<DeficitType>(0)) {
#elif defined(STOP_IF_DEFICIT_SIGN_CHANGES)
					if (step_count > 1 &&
						((previous_deficit_s > 0 && !(deficit_s > 0)) ||
						 (previous_deficit_s < 0 && !(deficit_s < 0)))) {
#else
					if (step_count > 1 && ((node_accessor.get_deficit() > 0 &&
											v_start_deficit < 0) ||
										   (node_accessor.get_deficit() < 0 &&
											v_start_deficit > 0))) {

						// remove everything but the path from the start node to
						// the final node from the tree
						tree.erase(std::begin(tree) + node_accessor.get_depth(),
								   std::end(tree));
						auto node_that_remains_in_the_tree = new_node;

						for (auto &depth : boost::adaptors::reverse(tree)) {
							depth.erase(
									std::remove_if(
											std::begin(depth), std::end(depth),
											[&node_that_remains_in_the_tree](
													const std::pair<
															NodeIterator,
															EdgeIterator>
															&tree_node) {
												return tree_node.first !=
													   node_that_remains_in_the_tree;
											}),
									std::end(depth));

							assert(depth.size() == 1);

							const auto edge_accessor =
									EdgeAccessor(N, depth.front().second);

							const auto &tail = edge_accessor.get_tail();
							const auto &head = edge_accessor.get_head();

							node_that_remains_in_the_tree =
									tail == node_that_remains_in_the_tree
											? head
											: tail;
						}
#endif
						for (auto node_it = nbegin; node_it != nend;
							 ++node_it) {
							auto node_accessor = NodeAccessor(N, node_it);
							if (!node_accessor.is_visited())
								node_accessor.set_potential(
										node_accessor.get_potential() + delta);
						}
						break;
					}
				}
#endif
			}
		}

#if START_NODE_SELECTION_METHOD == 1 && !defined(STOP_IF_DEFICIT_IS_ZERO) &&   \
		!defined(STOP_IF_DEFICIT_SIGN_CHANGES) &&                              \
		!defined(STOP_IF_NODE_DEFICIT_SIGN_CHANGES)
#ifdef SCALING
		if (num_visited != get_number_of_nodes(N) && phase == 0) {
#else
		if (num_visited != get_number_of_nodes(N)) {
#endif
			std::cerr << "Disconnected graphs are not supported with this "
						 "configuration."
					  << std::endl;
			exit(1);
		}
#endif

#ifdef GREEDY_DUAL_ASCENT
#ifdef ALTERNATION_QUEUE
		if (queue.gda())
			update_x_by_slack<Network, EdgeIterator, NodeAccessor,
							  EdgeAccessor>(N, ebegin, eend, statistics);
#else
		update_x_by_slack<Network, EdgeIterator, NodeAccessor, EdgeAccessor>(
				N, ebegin, eend, statistics);
#endif
#endif

#ifdef RESTORE_BALANCED_NODES
		update_x_by_tree<Network, NodeIterator, NodeAccessor, EdgeAccessor,
						 decltype(tree)>(N, tree, nbegin, nend);
#else
		update_x_by_tree<Network, NodeAccessor, EdgeAccessor, decltype(tree)>(
				N, tree);
#endif

#ifdef SCALING
		auto new_deficit_1 =
				compute_deficit_1<Network, NodeIterator, NodeAccessor,
								  DeficitType>(N, nbegin, nend);
		if (phase != 0 && last_deficit_1 == new_deficit_1)
			break;
		last_deficit_1 = new_deficit_1;
#endif

	} while (true);

#ifndef NDEBUG
	auto deficit_1 =
			compute_deficit_1<Network, NodeIterator, NodeAccessor, DeficitType>(
					N, nbegin, nend);
#ifdef SCALING
	assert(phase != 0 || deficit_1 == 0);
#else
	assert(deficit_1 == 0);
#endif
#endif

#if !defined(FORMATTED_OUTPUT) || !defined(NDEBUG)
	std::cout << "found solution after " << step_count
			  << (step_count == 1 ? " step" : " steps");
	const auto dual_objective_value =
			compute_dual_objective_value<Network, NodeIterator, NodeAccessor,
										 EdgeIterator, EdgeAccessor,
										 PotentialType>(N, nbegin, nend, ebegin,
														eend);
	std::cout << ", dual objective value = " << dual_objective_value
			  << std::endl;
#endif

	return statistics;
}
