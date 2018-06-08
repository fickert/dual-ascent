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

template <class GDAQueueType, class NonGDAQueueType> class GDAAlternationQueue {
public:
	using value_type = typename GDAQueueType::value_type;

	GDAAlternationQueue(const GDAQueueType &gda_queue,
						const NonGDAQueueType &non_gda_queue, bool use_gda)
			: gda_queue(gda_queue), non_gda_queue(non_gda_queue),
			  use_gda(use_gda) {}

	GDAAlternationQueue(GDAQueueType &&gda_queue,
						NonGDAQueueType &&non_gda_queue, bool use_gda)
			: gda_queue(gda_queue), non_gda_queue(non_gda_queue),
			  use_gda(use_gda) {}

	void push(const value_type &value, bool outgoing) {
		if (use_gda)
			gda_queue.push(value, outgoing);
		else {
			non_gda_queue.push(value, outgoing);
		}
	}

	template <typename DeficitType>
	auto pop(const DeficitType &deficit_s, const DeficitType &demand_s)
			-> value_type {
		assert(!empty());
		if (use_gda) {
			return gda_queue.pop(deficit_s, demand_s);
		} else {
			auto top = non_gda_queue.top(deficit_s);
			non_gda_queue.pop(deficit_s);
			return top;
		}
	}

	auto empty() const -> bool {
		return use_gda ? gda_queue.empty() : non_gda_queue.empty();
	}

	auto gda() const -> bool { return use_gda; }

private:
	GDAQueueType gda_queue;
	NonGDAQueueType non_gda_queue;

	const bool use_gda;
};
