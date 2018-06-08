/*******************************************************************************
* Copyright (c) 2016, Maximilian Fickert
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

#include <vector>

template <typename Network> class greedy_dual_ascent_avl_tree {
public:
#ifdef SCALING
	greedy_dual_ascent_avl_tree(Network &N, int phase)
			: phase(phase),
#else
	greedy_dual_ascent_avl_tree(Network &N) :
#endif
			  root(0), N(N) {
	}

	~greedy_dual_ascent_avl_tree() {
		auto remaining_arcs = std::vector<arc>();
		for (auto a : *this)
			remaining_arcs.push_back(a);
		for (auto a : remaining_arcs)
			remove_pointers(a);
	}

	void insert(arc a) {
		assert(a != 0);
		root = insert(root, a);
	}

	void remove(arc a) {
		assert(a != 0);
		if (!is_in_tree(a))
			return;
		if (a == root) {
			root = remove_from_tree(a);
			remove_pointers(a);
			if (root != 0)
				set_parent(root, 0);
		} else {
			auto parent = get_parent(a);
			auto replacement = remove_from_tree(a);
			remove_pointers(a);
			if (get_left(parent) == a)
				set_left(parent, replacement);
			else
				set_right(parent, replacement);
			if (replacement != 0)
				set_parent(replacement, parent);
			// update heights and sums and rebalance towards the root of the
			// tree
			arc grandparent;
			while (parent != root) {
				update_height_and_sums(parent);
				grandparent = get_parent(parent);
				if (get_left(grandparent) == parent) {
					set_left(grandparent, rebalance(parent));
					set_parent(get_left(grandparent), grandparent);
				} else {
					set_right(grandparent, rebalance(parent));
					set_parent(get_right(grandparent), grandparent);
				}
				parent = grandparent;
			}
			update_height_and_sums(parent);
			root = rebalance(parent);
		}
	}

	auto empty() const -> bool { return root == 0; }

	class iterator : std::iterator<std::input_iterator_tag, arc> {
	public:
		iterator() = delete;
		iterator(const iterator &) = default;

		iterator(greedy_dual_ascent_avl_tree &tree, arc a)
				: tree(tree), current(a) {}

		auto operator=(const iterator &other) -> iterator & {
			if (this != &other)
				current = other.current;
			return *this;
		};

		auto operator++() -> iterator & {
#ifndef NDEBUG
			auto previous = current;
#endif
			auto right = tree.get_right(current);
			if (right != 0) {
				// if the current node has a right child,
				// go to the leftmost node in the right subtree
				auto leftmost = right;
				do {
					current = leftmost;
				} while ((leftmost = tree.get_left(leftmost)) != 0);
			} else {
				// otherwise, go upwards in the tree to the first point where
				// the last node was a left child of the parent
				arc last;
				do {
					last = current;
					current = tree.get_parent(current);
				} while (current != 0 && tree.get_right(current) == last);
			}
#ifndef NDEBUG
			assert(previous != current);
			assert(previous == 0 || current == 0 ||
				   tree.get_key(previous) <= tree.get_key(current));
#endif
			return *this;
		}

		auto operator--() -> iterator & {
#ifndef NDEBUG
			auto previous = current;
#endif
			if (current == 0) {
				// the iterator is currently at the end position,
				// go back to the rightmost element in the tree
				current = tree.root;
				arc right;
				while ((right = tree.get_right(current)) != 0)
					current = right;
				return *this;
			}
			auto left = tree.get_left(current);
			if (left != 0) {
				// if the current node has a left child,
				// go to the rightmost node in the left subtree
				auto rightmost = left;
				do {
					current = rightmost;
				} while ((rightmost = tree.get_right(rightmost)) != 0);
			} else {
				// otherwise, go upwards in the tree to the first point where
				// the last node was a right child of the parent
				arc last;
				do {
					last = current;
					current = tree.get_parent(current);
				} while (current != 0 && tree.get_left(current) == last);
			}
#ifndef NDEBUG
			assert(previous != current);
			assert(previous == 0 || current == 0 ||
				   tree.get_key(previous) >= tree.get_key(current));
#endif
			return *this;
		}

		auto operator++(int) -> iterator & {
			auto retval = *this;
			operator++();
			return retval;
		}

		auto operator--(int) -> iterator & {
			auto retval = *this;
			operator--();
			return retval;
		}

		auto operator*() const -> arc { return current; }

		auto operator==(const iterator &other) const -> bool {
			return current == other.current;
		}

		auto operator!=(const iterator &other) const -> bool {
			return !operator==(other);
		}

	private:
		greedy_dual_ascent_avl_tree &tree;
		arc current;
	};

	auto begin() -> iterator {
		if (root == 0)
			return iterator(*this, 0);
		auto current = root;
		arc left;
		while ((left = get_left(current)) != 0)
			current = left;
		return iterator(*this, current);
	}

	auto end() -> iterator { return iterator(*this, 0); }

	auto get_prefix_sum(arc a) -> RationalType {
		assert(is_in_tree(a));
		auto prefix_sum = get_subtree_prefix_sum(get_left(a));
		prefix_sum += get_prefix_summand(a);
		auto child = a;
		arc parent;
		while ((parent = get_parent(child)) != 0) {
			if (get_right(parent) == child) {
				assert(get_left(parent) == 0 ||
					   get_key(get_left(parent)) <= get_key(a));
				prefix_sum += get_subtree_prefix_sum(get_left(parent));
				assert(get_key(parent) <= get_key(a));
				prefix_sum += get_prefix_summand(parent);
			}
			child = parent;
		}

#ifndef NDEBUG
		auto prefix_sum_ref = static_cast<decltype(prefix_sum)>(0);
		for (auto b : *this) {
			prefix_sum_ref += get_prefix_summand(b);
			if (b == a)
				break;
		}
		assert(prefix_sum_ref == prefix_sum);
#endif

		return prefix_sum;
	}

	auto get_postfix_sum(arc a) -> RationalType {
		assert(is_in_tree(a));
		auto postfix_sum = get_subtree_postfix_sum(get_right(a));
		auto child = a;
		arc parent;
		while ((parent = get_parent(child)) != 0) {
			if (get_left(parent) == child) {
				assert(get_right(parent) == 0 ||
					   get_key(get_right(parent)) >= get_key(a));
				postfix_sum += get_subtree_postfix_sum(get_right(parent));
				assert(get_key(parent) >= get_key(a));
				postfix_sum += get_postfix_summand(parent);
			}
			child = parent;
		}

#ifndef NDEBUG
		auto postfix_sum_ref = static_cast<decltype(postfix_sum)>(0);
		auto b_is_after_a = false;
		for (auto b : *this) {
			if (b_is_after_a) {
				postfix_sum_ref += get_postfix_summand(b);
			}
			if (b == a)
				b_is_after_a = true;
		}
		assert(postfix_sum_ref == postfix_sum);
#endif

		return postfix_sum;
	}

	auto top(RationalType demand_s) -> iterator {
		return iterator(*this, get_best_in_subtree(root, demand_s).first);
	}

	auto is_forward(arc a) -> RationalType {
#ifdef RESIDUAL
		return N.nodedata[N.G.tails[std::abs(a)]].visited;
#else
		return a > 0;
#endif
	}

	auto is_outgoing(arc a) -> RationalType {
#ifdef RESIDUAL
		assert(a != 0);
		return a > 0 ? N.arcdata[a].outgoing : N.arcdata[-a].outgoing_backward;
#else
		return is_forward(a);
#endif
	}

private:
	using RationalType = typename Network::RationalType;

	friend class iterator;

	auto get_best_in_subtree(arc a, RationalType demand_s)
			-> std::pair<arc, RationalType> {
		if (a == 0)
			return {0, 0};

		auto greedy_coefficient = [this, &demand_s](arc a) -> RationalType {
			assert(a != 0);
			return -demand_s + this->get_prefix_sum(a) +
				   this->get_postfix_sum(a);
		};

		auto greedy_coefficient_a = greedy_coefficient(a);

		if (greedy_coefficient_a > 0) {
			return get_best_in_subtree(get_right(a), demand_s);
		} else {
			auto best_in_left_subtree =
					get_best_in_subtree(get_left(a), demand_s);
			return best_in_left_subtree.first == 0
						   ? std::make_pair(a, greedy_coefficient_a)
						   : best_in_left_subtree;
		}
	}

	auto count() -> int {
		auto size = 0;
		for (auto a : *this)
			++size;
		return size;
	}

	void sanity_checks() {
#ifndef NDEBUG
		std::function<int(arc)> compute_height = [this,
												  &compute_height](arc a) {
			return a == 0 ? 0 : std::max(compute_height(get_left(a)),
										 compute_height(get_right(a))) +
										1;
		};

		std::function<RationalType(arc)> compute_subtree_prefix_sum =
				[this, &compute_subtree_prefix_sum](arc a) {
					return a == 0 ? 0
								  : compute_subtree_prefix_sum(get_left(a)) +
											compute_subtree_prefix_sum(
													get_right(a)) +
											get_prefix_summand(a);
				};

		std::function<RationalType(arc)> compute_subtree_postfix_sum =
				[this, &compute_subtree_postfix_sum](arc a) {
					return a == 0 ? 0
								  : compute_subtree_postfix_sum(get_left(a)) +
											compute_subtree_postfix_sum(
													get_right(a)) +
											get_postfix_summand(a);
				};

		arc last = 0;
		for (auto a : *this) {
			assert(a != 0 && "invalid node in tree");
			assert((last == 0 || get_key(last) <= get_key(a)) &&
				   "either some nodes are not sorted, or the iteration order "
				   "is wrong");
			assert(!has_left(a) || get_key(get_left(a)) <= get_key(a));
			assert(!has_right(a) || get_key(get_right(a)) >= get_key(a));
			assert(get_height(a) == compute_height(a) && "height not updated");
			assert(get_subtree_prefix_sum(a) == compute_subtree_prefix_sum(a) &&
				   "subtree prefix sum not updated");
			assert(get_subtree_postfix_sum(a) ==
						   compute_subtree_postfix_sum(a) &&
				   "subtree postfix sum not updated");
			assert(std::abs(get_height(get_left(a)) -
							get_height(get_right(a))) <= 1 &&
				   "tree is not balanced");
			assert((!has_left(a) || get_parent(get_left(a)) == a) &&
				   "inconsistent pointers");
			assert((!has_right(a) || get_parent(get_right(a)) == a) &&
				   "inconsistent pointers");
			last = a;
		}
#endif
	}

	void check_sorted() {
#ifndef NDEBUG
		arc last = 0;
		for (auto a : *this) {
			assert(a != 0 && "invalid node in tree");
			assert((last == 0 || get_key(last) <= get_key(a)) &&
				   "either some nodes are not sorted, or the iteration order "
				   "is wrong");
			last = a;
		}
#endif
	}

	void check_heights() {
#ifndef NDEBUG
		std::function<int(arc)> compute_height = [this,
												  &compute_height](arc a) {
			return a == 0 ? 0 : std::max(compute_height(get_left(a)),
										 compute_height(get_right(a))) +
										1;
		};

		for (auto a : *this) {
			assert(a != 0 && "invalid node in tree");
			assert(get_height(a) == compute_height(a) && "height not updated");
		}
#endif
	}

	auto insert(arc parent, arc a) -> arc {
		if (parent == 0) {
			// std::cout << "inserted " << a << std::endl;
			update_height_and_sums(a);
			return a;
		}
		if (get_key(a) > get_key(parent)) {
			// std::cout << "inserting right of " << parent << std::endl;
			set_right(parent, insert(get_right(parent), a));
			set_parent(get_right(parent), parent);
		} else {
			// std::cout << "inserting left of " << parent << std::endl;
			set_left(parent, insert(get_left(parent), a));
			set_parent(get_left(parent), parent);
		}
		update_height_and_sums(parent);
		return rebalance(parent);
	}

	auto remove_from_tree(arc a) -> arc {
		assert(a != 0);
		if (!has_left(a))
			return get_right(a);
		if (!has_right(a))
			return get_left(a);
		auto left = get_left(a);
		if (!has_right(left)) {
			auto right = get_right(a);
			set_right(left, right);
			set_parent(right, left);
			update_height_and_sums(left);
			return rebalance(left);
		} else {
			auto right = get_right(a);
			auto new_left = swap_with_max_in_subtree(a, left, left);
			assert(get_parent(new_left) != 0);
			auto replacement = get_parent(new_left);
			set_right(replacement, right);
			set_left(replacement, new_left);
			set_parent(right, replacement);
			update_height_and_sums(replacement);
			return rebalance(replacement);
		}
	}

	auto swap_with_max_in_subtree(arc to_be_removed, arc current_child,
								  arc first_child) -> arc {
		auto right = get_right(current_child);
		assert(right != 0);
		if (has_right(right)) {
			set_right(current_child,
					  swap_with_max_in_subtree(to_be_removed, right,
											   first_child));
			set_parent(get_right(current_child), current_child);
		} else {
			auto right_left = get_left(right);
			set_left(right, get_left(to_be_removed));
			set_parent(get_left(right), right);
			set_right(current_child, right_left);
			if (right_left != 0)
				set_parent(right_left, current_child);
		}
		update_height_and_sums(current_child);
		return rebalance(current_child);
	}

	void remove_pointers(arc a) {
		set_parent(a, 0);
		set_left(a, 0);
		set_right(a, 0);
	}

	auto rebalance(arc parent) -> arc {
		auto balance =
				get_height(get_left(parent)) - get_height(get_right(parent));
		if (balance == -2) {
			// right subtree is bigger
			auto height_rr = get_height(get_right(get_right(parent)));
			auto height_rl = get_height(get_left(get_right(parent)));
			if (height_rr >= height_rl) {
				return rotate_left(parent);
			} else {
				set_right(parent, rotate_right(get_right(parent)));
				return rotate_left(parent);
			}
		} else if (balance == 2) {
			// left subtree is bigger
			auto height_ll = get_height(get_left(get_left(parent)));
			auto height_lr = get_height(get_right(get_left(parent)));
			if (height_ll >= height_lr) {
				return rotate_right(parent);
			} else {
				set_left(parent, rotate_left(get_left(parent)));
				return rotate_right(parent);
			}
		}
		return parent;
	}

	auto rotate_left(arc anchor) -> arc {
		assert(!has_left(anchor) || get_parent(get_left(anchor)) == anchor);
		assert(!has_right(anchor) || get_parent(get_right(anchor)) == anchor);
		assert(has_right(anchor));
		assert(!has_left(get_right(anchor)) ||
			   get_parent(get_left(get_right(anchor))) == get_right(anchor));
		assert(!has_right(get_right(anchor)) ||
			   get_parent(get_right(get_right(anchor))) == get_right(anchor));
		assert(anchor != 0);
		auto right = get_right(anchor);
		assert(right != 0);
		set_parent(right, get_parent(anchor));
		auto right_left = get_left(right);
		set_right(anchor, right_left);
		if (right_left != 0)
			set_parent(right_left, anchor);
		set_left(right, anchor);
		set_parent(anchor, right);
		update_height_and_sums(anchor);
		update_height_and_sums(right);
		return right;
	}

	auto rotate_right(arc anchor) -> arc {
		assert(!has_left(anchor) || get_parent(get_left(anchor)) == anchor);
		assert(!has_right(anchor) || get_parent(get_right(anchor)) == anchor);
		assert(has_left(anchor));
		assert(!has_left(get_left(anchor)) ||
			   get_parent(get_left(get_left(anchor))) == get_left(anchor));
		assert(!has_right(get_left(anchor)) ||
			   get_parent(get_right(get_left(anchor))) == get_left(anchor));
		assert(anchor != 0);
		auto left = get_left(anchor);
		assert(left != 0);
		set_parent(left, get_parent(anchor));
		auto left_right = get_right(left);
		set_left(anchor, left_right);
		if (left_right != 0)
			set_parent(left_right, anchor);
		set_right(left, anchor);
		set_parent(anchor, left);
		update_height_and_sums(anchor);
		update_height_and_sums(left);
		return left;
	}

	void update_height_and_sums(arc a) {
		update_height(a);
		update_pre_and_postfix_sums(a);
	}

	void update_height(arc parent) {
		if (parent == 0)
			return;
		auto height_l = get_height(get_left(parent));
		auto height_r = get_height(get_right(parent));
		set_height(parent, std::max(height_l, height_r) + 1);
	}

	void update_pre_and_postfix_sums(arc a) {
		if (a == 0)
			return;
		auto left = get_left(a);
		auto right = get_right(a);
		set_subtree_prefix_sum(a, get_subtree_prefix_sum(left) +
										  get_subtree_prefix_sum(right) +
										  get_prefix_summand(a));
		set_subtree_postfix_sum(a, get_subtree_postfix_sum(left) +
										   get_subtree_postfix_sum(right) +
										   get_postfix_summand(a));
	}

	void set_subtree_prefix_sum(arc a, RationalType subtree_prefix_sum) {
		assert(a != 0);
		if (a > 0)
			N.arcdata[a].subtree_prefix_sum = subtree_prefix_sum;
		else
			N.arcdata[-a].subtree_prefix_sum_backward = subtree_prefix_sum;
	}

	void set_subtree_postfix_sum(arc a, RationalType subtree_postfix_sum) {
		assert(a != 0);
		if (a > 0)
			N.arcdata[a].subtree_postfix_sum = subtree_postfix_sum;
		else
			N.arcdata[-a].subtree_postfix_sum_backward = subtree_postfix_sum;
	}

	auto get_subtree_prefix_sum(arc a) -> RationalType {
		return a == 0 ? 0 : (a > 0 ? N.arcdata[a].subtree_prefix_sum
								   : N.arcdata[-a].subtree_prefix_sum_backward);
	}

	auto get_subtree_postfix_sum(arc a) -> RationalType {
		return a == 0 ? 0
					  : (a > 0 ? N.arcdata[a].subtree_postfix_sum
							   : N.arcdata[-a].subtree_postfix_sum_backward);
	}

	auto get_capacity(arc a) -> RationalType {
#ifdef RESIDUAL
#ifdef SCALING
		return is_outgoing(a) == is_forward(a)
					   ? scale(N.arcdata[std::abs(a)].capacity) -
								 N.arcdata[std::abs(a)].xlower
					   : N.arcdata[std::abs(a)].xlower;
#else
		return is_outgoing(a) == is_forward(a)
					   ? N.arcdata[std::abs(a)].capacity -
								 N.arcdata[std::abs(a)].xlower
					   : N.arcdata[std::abs(a)].xlower;
#endif
#else
#ifdef SCALING
		return scale(N.arcdata[std::abs(a)].capacity);
#else
		return N.arcdata[std::abs(a)].capacity;
#endif
#endif
	}

	auto get_prefix_summand(arc a) -> RationalType {
		assert(a != 0);
		return is_outgoing(a) ? -get_capacity(a) : 0;
	}

	auto get_postfix_summand(arc a) -> RationalType {
		assert(a != 0);
		return is_outgoing(a) ? 0 : get_capacity(a);
	}

	inline auto is_in_tree(arc a) -> bool {
		assert(a != 0);
		return a == root || get_parent(a) != 0;
	}

	inline auto get_key(arc a) -> RationalType {
		assert(a != 0);
		return a > 0 ? N.arcdata[a].key : N.arcdata[-a].key_backward;
	}

	inline void set_key(arc a, RationalType key) {
		assert(a != 0);
		if (a > 0)
			N.arcdata[a].key = key;
		else
			N.arcdata[-a].key_backward = key;
	}

	inline auto has_left(arc a) -> bool {
		assert(a != 0);
		return a > 0 ? N.arcdata[a].left != 0
					 : N.arcdata[-a].left_backward != 0;
	}

	inline auto get_left(arc a) -> arc {
		assert(a != 0);
		return a > 0 ? N.arcdata[a].left : N.arcdata[-a].left_backward;
	}

	inline void set_left(arc a, arc left) {
		assert(a != 0);
		if (a > 0)
			N.arcdata[a].left = left;
		else
			N.arcdata[-a].left_backward = left;
	}

	inline auto has_right(arc a) -> bool {
		assert(a != 0);
		return a > 0 ? N.arcdata[a].right != 0
					 : N.arcdata[-a].right_backward != 0;
	}

	inline auto get_right(arc a) -> arc {
		assert(a != 0);
		return a > 0 ? N.arcdata[a].right : N.arcdata[-a].right_backward;
	}

	inline void set_right(arc a, arc right) {
		assert(a != 0);
		if (a > 0)
			N.arcdata[a].right = right;
		else
			N.arcdata[-a].right_backward = right;
	}

	inline auto get_parent(arc a) -> arc {
		assert(a != 0);
		return a > 0 ? N.arcdata[a].parent : N.arcdata[-a].parent_backward;
	}

	inline void set_parent(arc a, arc parent) {
		assert(a != 0);
		if (a > 0)
			N.arcdata[a].parent = parent;
		else
			N.arcdata[-a].parent_backward = parent;
	}

	inline auto get_height(arc a) -> int {
		return a == 0 ? 0 : (a > 0 ? N.arcdata[a].height
								   : N.arcdata[-a].height_backward);
	}

	inline void set_height(arc a, int height) {
		assert(a != 0);
		if (a > 0)
			N.arcdata[a].height = height;
		else
			N.arcdata[-a].height_backward = height;
	}

#ifdef SCALING
	inline auto scale(const RationalType &x) const -> RationalType {
		return x < 0 ? -(-x >> phase << phase) : x >> phase << phase;
	}

	const int phase;
#endif

	arc root;
	Network &N;
};

template <typename T, typename Network> class greedy_dual_ascent_queue {

public:
	using value_type = T;

#ifdef SCALING
	greedy_dual_ascent_queue(Network &N, int phase)
			: phase(phase), tree(N, phase),
#else
	greedy_dual_ascent_queue(Network &N)
			: tree(N),
#endif
			  N(N) {
	}

	void push(const value_type &value, bool outgoing) {
#ifdef RESIDUAL
		auto tail_in_s = N.nodedata[N.G.tails[*value.second]].visited;
		auto forward = tail_in_s == outgoing;
		if (forward) {
			auto a = *value.second;
			N.arcdata[a].key = outgoing ? value.first : -value.first;
			N.arcdata[a].outgoing = outgoing;
			tree.insert(a);
		} else {
			auto a = -*value.second;
			N.arcdata[-a].key_backward = outgoing ? value.first : -value.first;
			N.arcdata[-a].outgoing_backward = outgoing;
			tree.insert(a);
		}
#else
		assert(outgoing == N.nodedata[N.G.tails[*value.second]].visited);
		if (outgoing) {
			auto a = *value.second;
			N.arcdata[a].key = value.first;
			tree.insert(a);
		} else {
			auto a = -*value.second;
			N.arcdata[-a].key_backward = value.first;
			tree.insert(a);
		}
#endif
	}

	void check_all_arcs() {
#ifndef NDEBUG
		for (auto a : tree)
			assert(N.nodedata[N.G.tails[std::abs(a)]].visited ^
				   N.nodedata[N.G.heads[std::abs(a)]].visited);
#endif
	}

	template <typename DeficitType>
	auto pop(const DeficitType &deficit_s, const DeficitType &demand_s)
			-> value_type {
		assert(!empty());

#ifdef RESIDUAL
		auto max_point = tree.top(deficit_s);
#else
		auto max_point = tree.top(demand_s);
#endif

#ifdef SCALING
		if (phase > 0 && max_point == std::end(tree))
			--max_point;
#endif
		assert(max_point != std::end(tree));

		auto key = [this](arc a) -> decltype(N.arcdata.front().key) {
			assert(a != 0);
			return a > 0 ? N.arcdata[a].key : N.arcdata[-a].key_backward;
		};

#ifndef NDEBUG
		auto max_point_plus_one = max_point;
		++max_point_plus_one;
		if (max_point_plus_one != std::end(tree)) {
			bool found_value_less_or_equal_zero = false;
			for (auto some_max_point = max_point;
				 some_max_point != std::end(tree); ++some_max_point) {
				if (key(*some_max_point) != key(*max_point))
					break;
#ifdef RESIDUAL
				if (-deficit_s + tree.get_prefix_sum(*some_max_point) +
							tree.get_postfix_sum(*some_max_point) <=
					0) {
#else
				if (-demand_s + tree.get_prefix_sum(*some_max_point) +
							tree.get_postfix_sum(*some_max_point) <=
					0) {
#endif
					found_value_less_or_equal_zero = true;
					break;
				}
			}
			assert(found_value_less_or_equal_zero);
		}
#endif

// tie break on residual capacity
#ifdef SCALING
		auto get_residual_capacity = [this, &deficit_s](arc a) -> decltype(
				N.arcdata.front().capacity) {
			auto scale = [this](const RationalType &x) -> RationalType {
				return x < 0 ? -(-x >> phase << phase) : x >> phase << phase;
			};
			return (deficit_s < 0) == tree.is_forward(a)
						   ? scale(N.arcdata[std::abs(a)].capacity) -
									 N.arcdata[std::abs(a)].xlower
						   : N.arcdata[std::abs(a)].xlower;
		};
#else
		auto get_residual_capacity = [this, &deficit_s](arc a) -> decltype(
				N.arcdata.front().capacity) {
			return (deficit_s < 0) == tree.is_forward(a)
						   ? N.arcdata[std::abs(a)].capacity -
									 N.arcdata[std::abs(a)].xlower
						   : N.arcdata[std::abs(a)].xlower;
		};
#endif

		auto max_point_residual_capacity = get_residual_capacity(*max_point);

		auto break_ties = [&max_point, &max_point_residual_capacity,
						   &get_residual_capacity](
				const decltype(max_point) &other_max_point) {
			auto other_max_point_residual_capacity =
					get_residual_capacity(*other_max_point);
			// first tie breaker: residual capacity
			if (other_max_point_residual_capacity >
				max_point_residual_capacity) {
				max_point = other_max_point;
				max_point_residual_capacity = other_max_point_residual_capacity;
				// second tie breaker: id
			} else if (other_max_point_residual_capacity ==
							   max_point_residual_capacity &&
					   *other_max_point < *max_point) {
				max_point = other_max_point;
			}
		};

		auto max_point_before_tie_breaking = max_point;

		// look for elements with the same key but higher residual capacity
		// ordered after the current one
		auto other_max_point = max_point;
		while (++other_max_point != std::end(tree)) {
			assert(key(*other_max_point) >= key(*max_point));
			if (key(*other_max_point) != key(*max_point))
				break;
			break_ties(other_max_point);
		}

		// look for elements with the same key but higher residual capacity
		// ordered before the current one
		if (max_point_before_tie_breaking != std::begin(tree)) {
			other_max_point = max_point_before_tie_breaking;
			do {
				--other_max_point;
				assert(key(*other_max_point) <= key(*max_point));
				if (key(*other_max_point) != key(*max_point))
					break;
				break_ties(other_max_point);
			} while (other_max_point != std::begin(tree));
		}

		auto top = make_pair(key(*max_point),
							 typename value_type::second_type(*max_point));
		tree.remove(*max_point);

		// remove arcs where both nodes are visited
		auto new_node = tree.is_forward(*max_point)
								? N.G.heads[std::abs(*max_point)]
								: N.G.tails[std::abs(*max_point)];
		assert(!N.nodedata[new_node].visited);
		for (auto a : N.G.incident_edges[new_node]) {
#ifdef RESIDUAL
			tree.remove(a);
#endif
			tree.remove(-a);
		}

		return top;
	}

	void remove(arc a, bool forward) { tree.remove(forward ? a : -a); }

	auto empty() const -> bool { return tree.empty(); }

private:
#ifdef SCALING
	const int phase;
#endif

	greedy_dual_ascent_avl_tree<Network> tree;
	Network &N;
};
