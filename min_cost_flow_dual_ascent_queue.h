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

#include <cassert>

template <class InternalQueueType> class DualAscentQueue {
public:
	using value_type = typename InternalQueueType::value_type;

#ifdef SCALING
	DualAscentQueue(const InternalQueueType &s_in,
					const InternalQueueType &s_out, const int phase)
			: s_in(s_in), s_out(s_out), phase(phase) {}

	DualAscentQueue(InternalQueueType &&s_in, InternalQueueType &&s_out,
					const int phase)
			: s_in(s_in), s_out(s_out), phase(phase) {}
#else
	DualAscentQueue(const InternalQueueType &s_in,
					const InternalQueueType &s_out)
			: s_in(s_in), s_out(s_out) {}

	DualAscentQueue(InternalQueueType &&s_in, InternalQueueType &&s_out)
			: s_in(s_in), s_out(s_out) {}
#endif

	void push(const typename InternalQueueType::value_type &value,
			  bool outgoing) {
		auto &queue = outgoing ? s_out : s_in;
		queue.push(value);
	}

	template <typename DeficitType>
	auto top(const DeficitType &deficit_s) ->
			typename InternalQueueType::value_type {
		assert(!empty());
		if (deficit_s < 0 || s_in.empty()) {
#ifdef SCALING
			if (phase > 0 && s_out.empty())
				return {-s_in.top().first, s_in.top().second};
#endif
			assert(!s_out.empty());
			return s_out.top();
		} else {
			assert(!s_in.empty());
			return {-s_in.top().first, s_in.top().second};
		}
	}

	template <typename DeficitType> void pop(DeficitType deficit_s) {
		assert(!empty());
#ifdef SCALING
		auto &queue = deficit_s < 0 || s_in.empty()
							  ? (phase > 0 && s_out.empty() ? s_in : s_out)
							  : s_in;
#else
		auto &queue = deficit_s < 0 || s_in.empty() ? s_out : s_in;
#endif
		assert(!queue.empty());
		queue.pop();
	}

	auto empty() const -> bool { return s_in.empty() && s_out.empty(); }

private:
	InternalQueueType s_in;
	InternalQueueType s_out;

#ifdef SCALING
	const int phase;
#endif
};
