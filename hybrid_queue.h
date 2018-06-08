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

#include <queue>
#include <utility>
#include <vector>

template <class K, class V> class hybrid_queue {
public:
	using value_type = std::pair<K, V>;

	hybrid_queue()
			: bucket(),
			  pqueue([](const value_type &lhs, const value_type &rhs) {
				  return lhs.first > rhs.first;
			  }) {}

	void reserve_bucket(size_t new_cap) const { bucket.reserve(new_cap); }

	void push(const value_type &value) {
		const auto &key = value.first;
		if (key > min_key) {
			pqueue.push(value);
			return;
		}
		if (key == min_key) {
			bucket.push_back(value);
			return;
		}
		move_bucket_to_queue();
		bucket.push_back(value);
		min_key = key;
	}

	auto top() -> value_type {
		assert(!empty());
		if (bucket.empty())
			return pqueue.top();
#ifndef NDEBUG
		if (!pqueue.empty())
			for (const auto &entry : bucket)
				assert(entry.first <= pqueue.top().first);
#endif
		return bucket.back();
	}

	void pop() {
		assert(!empty());
		if (bucket.empty()) {
			min_key = pqueue.top().first;
			pqueue.pop();
		} else {
			bucket.pop_back();
		}
	}

	auto empty() const -> bool { return bucket.empty() && pqueue.empty(); }

	void clear() {
		bucket.clear();
		pqueue.clear();
	}

private:
	void move_bucket_to_queue() {
		for (const auto &entry : bucket)
			pqueue.push(entry);
		bucket.clear();
	}

	K min_key;
	std::vector<value_type> bucket;
	std::priority_queue<value_type, std::vector<value_type>,
						bool (*)(const value_type &, const value_type &rhs)>
			pqueue;
};

template <class K, class V> class hybrid_vector_queue {

public:
	using value_type = std::pair<K, V>;
	using pq_value_type = std::pair<K, std::vector<V>>;

	hybrid_vector_queue()
			: bucket(),
			  pqueue([](const pq_value_type &lhs, const pq_value_type &rhs) {
				  return lhs.first > rhs.first;
			  }) {}

	void reserve_bucket(size_t new_cap) const { bucket.reserve(new_cap); }

	void push(const value_type &value) {
		const auto &key = value.first;
		if (key > min_key) {
			pqueue.push({value.first, std::vector<V>{value.second}});
			return;
		}
		if (key == min_key) {
			bucket.push_back(value.second);
			return;
		}
		if (!bucket.empty())
			pqueue.push({min_key, std::move(bucket)});
		bucket = {value.second};
		min_key = key;
	}

	auto top() -> value_type {
		assert(!empty());
		if (bucket.empty()) {
			assert(!pqueue.top().second.empty());
			return {pqueue.top().first, pqueue.top().second.back()};
		}
#ifndef NDEBUG
		if (!pqueue.empty())
			assert(min_key <= pqueue.top().first);
#endif
		return {min_key, bucket.back()};
	}

	void pop() {
		assert(!empty());
		if (bucket.empty()) {
			min_key = pqueue.top().first;
			const_cast<std::vector<V> &>(pqueue.top().second).pop_back();
			if (pqueue.top().second.empty())
				pqueue.pop();
		} else {
			bucket.pop_back();
		}
	}

	auto empty() const -> bool { return bucket.empty() && pqueue.empty(); }

	void clear() {
		bucket.clear();
		pqueue.clear();
	}

private:
	void move_bucket_to_queue() {
		for (const auto &entry : bucket)
			pqueue.push(entry);
		bucket.clear();
	}

	K min_key;
	std::vector<V> bucket;
	std::priority_queue<pq_value_type, std::vector<pq_value_type>,
						bool (*)(const pq_value_type &, const pq_value_type &)>
			pqueue;
};
