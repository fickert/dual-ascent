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

#include <algorithm>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/predicate.hpp>
#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string/trim.hpp>
#include <boost/foreach.hpp>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>
#include <boost/range/adaptor/reversed.hpp>
#include <boost/rational.hpp>
#include <fstream>
#include <iostream>
#include <limits>
#include <vector>

using namespace std;
using namespace boost::property_tree;

const ptree &empty_ptree() {
	static ptree t;
	return t;
}

typedef unsigned int node;
typedef int arc;

template <typename IntegerType, typename RationalType> struct BasicNodeData {
	BasicNodeData() : demand(0), potential(0) {}

	// input parameter
	IntegerType demand;

	// dual variables
	RationalType potential;
};

template <typename IntegerType, typename RationalType>
struct DualAscentNodeData : public BasicNodeData<IntegerType, RationalType> {
	DualAscentNodeData()
			: BasicNodeData<IntegerType, RationalType>(),
#ifdef RESTORE_BALANCED_NODES
			  deficit_delta(0),
#endif
			  depth(-1), visited(false), net_inflow(0) {
	}

#ifdef RESTORE_BALANCED_NODES
	IntegerType deficit_delta;
#endif
	int depth;
	bool visited;
	RationalType net_inflow;
};

template <typename RationalType> struct BasicArcData {
	BasicArcData()
			:
#ifdef GREEDY_DUAL_ASCENT
			  parent(0),
			  left(0), right(0), key(0),
#ifdef RESIDUAL
			  outgoing(false),
#endif
			  height(0), subtree_prefix_sum(0), subtree_postfix_sum(0),
			  parent_backward(0), left_backward(0), right_backward(0),
			  key_backward(0),
#ifdef RESIDUAL
			  outgoing_backward(false),
#endif
			  height_backward(0), subtree_prefix_sum_backward(0),
			  subtree_postfix_sum_backward(0),
#endif
			  capacity(0), cost(0), xlower(0) {
	}

#ifdef GREEDY_DUAL_ASCENT
	arc parent, left, right;
	RationalType key;
#ifdef RESIDUAL
	bool outgoing;
#endif
	int height;
	RationalType subtree_prefix_sum, subtree_postfix_sum;
	arc parent_backward, left_backward, right_backward;
	RationalType key_backward;
#ifdef RESIDUAL
	bool outgoing_backward;
#endif
	int height_backward;
	RationalType subtree_prefix_sum_backward, subtree_postfix_sum_backward;
#endif

	// input parameter
	RationalType capacity;
	RationalType cost;

	// primal variables - for x
	RationalType xlower;
};

template <typename RationalType>
struct DualAscentRBNArcData : public BasicArcData<RationalType> {
	DualAscentRBNArcData() : BasicArcData<RationalType>(), flow_delta(0) {}

	RationalType flow_delta;
};

// Network
template <typename Graph, typename IType, typename RType, typename NodeData,
		  typename ArcData>
class Network {
public:
	using GraphType = Graph;
	using IntegerType = IType;
	using RationalType = RType;
	using NodeDataType = NodeData;
	using ArcDataType = ArcData;

	Graph &G;
	vector<NodeData> nodedata;
	vector<ArcData> arcdata;

	Network(Graph &G)
			: G(G), nodedata(G.no_of_vertices + 1),
			  arcdata(G.no_of_edges + 1){};
	Network(Graph &G, const string &filename);
	auto calculate_primal_objective_value() const -> RationalType;
	void saturate_negative_cost_arcs();

	void write_dimacs(ostream &os) const;

	void reset();

#ifdef SCALING
	RationalType max_capacity;
	RationalType max_demand;
#endif

private:
	void read_graphml(const string &filename);
	void read_dimacs(const string &filename);
};

template <typename Graph, typename IType, typename RType, typename NodeData,
		  typename ArcData>
Network<Graph, IType, RType, NodeData, ArcData>::Network(Graph &G,
														 const string &filename)
		: G(G), nodedata(G.no_of_vertices + 1),
#ifdef SCALING
		  arcdata(G.no_of_edges + 1), max_capacity(0), max_demand(0) {
#else
		  arcdata(G.no_of_edges + 1) {
#endif

	if (boost::ends_with(filename, ".graphml")) {
		// if the file name ends with .graphml, read it as graphml
		read_graphml(filename);
	} else {
		// otherwise assume the graph is in dimacs format
		read_dimacs(filename);
	}

#ifndef NDEBUG
	// sanity checks
	auto sum_demands = static_cast<decltype(nodedata.front().demand)>(0);
	for (const auto &data : nodedata)
		sum_demands += data.demand;
	assert(sum_demands == 0 && "the sum of all demands must be zero.");
#endif
};

template <typename Graph, typename IType, typename RType, typename NodeData,
		  typename ArcData>
void Network<Graph, IType, RType, NodeData, ArcData>::read_graphml(
		const string &filename) {
	ptree tree;
	read_xml(filename, tree);

	string costs;
	string capacities;

	// find out keys representing costs/capacities
	for (const auto &element : tree.get_child("graphml")) {
		if (element.first != "key")
			continue;
		auto attribute_name = element.second.get<string>(
				ptree::path_type("<xmlattr>/attr.name", '/'));
		if (attribute_name == "costs" || attribute_name == "cost")
			costs = element.second.get<string>("<xmlattr>.id");
		if (attribute_name == "capacities" || attribute_name == "capacity")
			capacities = element.second.get<string>("<xmlattr>.id");
	}

	if (costs.empty()) {
		cerr << "cost attribute not found!" << endl;
		exit(1);
	}

	if (capacities.empty()) {
		cerr << "capacity attribute not found!" << endl;
		exit(1);
	}

	const auto &graph = tree.get_child("graphml.graph");

	// set costs/capacities/demands
	int edgeid = 0;
	for (const auto &element : graph) {
		if (element.first == "node") {
			auto nodeid = element.second.get<int>("<xmlattr>.id");
			nodedata[nodeid].demand = element.second.get<int>("data");
#ifdef SCALING
			max_demand = max(max_demand, abs(nodedata[nodeid].demand));
#endif
		}
		if (element.first == "edge") {
			++edgeid;
			for (const auto &child : element.second) {
				if (child.first != "data")
					continue;
				if (child.second.get<string>("<xmlattr>.key") == costs)
					arcdata[edgeid].cost = child.second.get_value<int>();
				if (child.second.get<string>("<xmlattr>.key") == capacities) {
					arcdata[edgeid].capacity = child.second.get_value<int>();
#ifdef SCALING
					max_capacity = max(max_capacity, arcdata[edgeid].capacity);
#endif
				}
			}
		}
	}
}

template <typename Graph, typename IType, typename RType, typename NodeData,
		  typename ArcData>
void Network<Graph, IType, RType, NodeData, ArcData>::read_dimacs(
		const string &filename) {
	ifstream dimacs_file(filename);
	string line;

	// parse node descriptors
	while (getline(dimacs_file, line)) {
		boost::trim(line);
		if (boost::starts_with(line, "c") || boost::starts_with(line, "p"))
			continue;
		if (boost::starts_with(line, "a"))
			break;
		assert(boost::starts_with(line, "n") &&
			   "here should be a node descriptor");

		auto node_tokens = vector<string>();
		boost::split(node_tokens, line, boost::is_any_of(" \t"),
					 boost::token_compress_on);

		assert(stoul(node_tokens[1]) > 0 &&
			   stoul(node_tokens[1]) <= G.no_of_vertices &&
			   "node ids must be in the range [1, n]");

		nodedata[stoul(node_tokens[1])].demand = -stoi(node_tokens[2]);
#ifdef SCALING
		max_demand =
				max(max_demand, abs(nodedata[stoul(node_tokens[1])].demand));
#endif
	}

	int edgeid = 0;

	// parse arc descriptors
	do {
		boost::trim(line);
		if (boost::starts_with(line, "c") || line.empty())
			continue;
		assert(boost::starts_with(line, "a") &&
			   "here should be an arc descriptor");
		++edgeid;

		auto arc_tokens = vector<string>();
		boost::split(arc_tokens, line, boost::is_any_of(" \t"),
					 boost::token_compress_on);

		if (stoi(arc_tokens[3]) != 0) {
			cerr << "currently only networks with minimum flow of 0 are "
					"supported."
				 << endl;
			exit(1);
		}

		arcdata[edgeid].capacity = stoi(arc_tokens[4]);
#ifdef SCALING
		max_capacity = max(max_capacity, arcdata[edgeid].capacity);
#endif
		arcdata[edgeid].cost = stoi(arc_tokens[5]);
	} while (getline(dimacs_file, line));
}

template <typename Graph, typename IType, typename RType, typename NodeData,
		  typename ArcData>
void Network<Graph, IType, RType, NodeData, ArcData>::write_dimacs(
		ostream &os) const {
	// problem line
	os << "p min " << G.no_of_vertices << " " << G.no_of_edges << '\n';

	// node descriptors
	for (auto n = 1u; n <= G.no_of_vertices; ++n) {
		const auto &data = nodedata[n];
		if (data.demand != 0)
			os << "n " << n << " " << -data.demand << '\n';
	}

	// arc descriptors
	for (auto a = 1u; a <= G.no_of_edges; ++a) {
		const auto &data = arcdata[a];
		os << "a " << G.tails[a] << " " << G.heads[a] << " 0 " << data.capacity
		   << " " << data.cost << '\n';
	}
	os.flush();
}

template <typename Graph, typename IType, typename RType, typename NodeData,
		  typename ArcData>
auto Network<Graph, IType, RType, NodeData,
			 ArcData>::calculate_primal_objective_value() const -> RType {
	return accumulate(begin(arcdata) + 1, end(arcdata), static_cast<RType>(0),
					  [](RType value, const ArcData &arcdata) {
						  return value + arcdata.xlower * arcdata.cost;
					  });
}

template <typename Graph, typename IType, typename RType, typename NodeData,
		  typename ArcData>
void Network<Graph, IType, RType, NodeData,
			 ArcData>::saturate_negative_cost_arcs() {
	for (auto a = 1u; a <= G.no_of_edges; ++a) {
		if (arcdata[a].cost < 0) {
			arcdata[a].xlower = arcdata[a].capacity;
			nodedata[G.tails[a]].net_inflow -= arcdata[a].capacity;
			nodedata[G.heads[a]].net_inflow += arcdata[a].capacity;
		}
	}
}

template <typename Graph, typename IType, typename RType, typename NodeData,
		  typename ArcData>
void Network<Graph, IType, RType, NodeData, ArcData>::reset() {
	for (auto &data : arcdata)
		data.xlower = 0;
	for (auto &data : nodedata) {
		data.net_inflow = 0;
		data.potential = 0;
	}
}

// Graph
template <typename IntegerType, typename RationalType> class Graph {

public:
	unsigned int no_of_vertices;
	unsigned int no_of_edges;
	vector<node> heads;
	vector<node> tails;
	vector<vector<int>> incident_edges;
	arc new_edge(node, node);
	arc new_edge(arc, node, node);

	Graph(const string &filename)
			: no_of_vertices(0), no_of_edges(0), heads(), tails(),
			  incident_edges() {

		if (boost::ends_with(filename, ".graphml")) {
			// if the file name ends with .graphml, read it as graphml
			read_graphml(filename);
		} else {
			// otherwise assume the graph is in dimacs format
			read_dimacs(filename);
		}
	}

	void read_graph(string filepath, int m);

private:
	void read_graphml(const string &filename);
	void read_dimacs(const string &filename);

	void initialize_internal_data_structures(int n, int m);
};

template <typename IntegerType, typename RationalType>
void Graph<IntegerType, RationalType>::read_graphml(const string &filename) {
	ptree tree;
	read_xml(filename, tree);

	const ptree &graphml = tree.get_child("graphml", empty_ptree());
	const ptree &graph = graphml.get_child("graph", empty_ptree());

	int n = 0;
	int m = 0;
	int nodeid;

	// count nodes and edges
	BOOST_FOREACH (const ptree::value_type &nore, graph) {
		const ptree &nore_attrs =
				nore.second.get_child("<xmlattr>", empty_ptree());
		BOOST_FOREACH (const ptree::value_type &nore_attr, nore_attrs) {
			if (strncmp(nore_attr.first.data(), "id", 2) == 0) {
				nodeid = stoi(nore_attr.second.data());
				n = max(n, nodeid);
			}
			if (strncmp(nore_attr.first.data(), "source", 6) == 0)
				++m;
		}
	}

	initialize_internal_data_structures(n, m);

	// parse edges
	BOOST_FOREACH (const ptree::value_type &nore, graph) {

		const ptree &nore_attrs =
				nore.second.get_child("<xmlattr>", empty_ptree());
		bool edge = false;
		int source = 0;
		int target = 0;
		BOOST_FOREACH (const ptree::value_type &nore_attr, nore_attrs) {
			if (strncmp(nore_attr.first.data(), "id", 2) != 0) {
				if (strncmp(nore_attr.first.data(), "source", 6) == 0) {
					edge = true;
					source = stoi(nore_attr.second.data());
				}
				if (strncmp(nore_attr.first.data(), "target", 6) == 0) {
					assert(edge);
					target = stoi(nore_attr.second.data());
				}
			}
		}

		if (edge) {
			++no_of_edges;
			new_edge(no_of_edges, source, target);
		}
	}
}

template <typename IntegerType, typename RationalType>
void Graph<IntegerType, RationalType>::read_dimacs(const string &filename) {
	ifstream dimacs_file(filename);
	string line;

	// skip to problem description line
	while (getline(dimacs_file, line)) {
		boost::trim(line);
		if (boost::starts_with(line, "p"))
			break;
	}

	auto problem_tokens = vector<string>();
	boost::split(problem_tokens, line, boost::is_any_of(" \t"),
				 boost::token_compress_on);
	assert(problem_tokens[0] == "p");
	assert(problem_tokens[1] == "min");
	auto n = stoul(problem_tokens[2]);
	auto m = stoul(problem_tokens[3]);

	initialize_internal_data_structures(n, m);

	// skip to arc descriptors
	while (getline(dimacs_file, line)) {
		boost::trim(line);
		if (boost::starts_with(line, "a"))
			break;
	}

	// parse arc descriptors
	do {
		boost::trim(line);
		if (boost::starts_with(line, "c") || line.empty())
			continue;
		assert(boost::starts_with(line, "a") &&
			   "here should be an arc descriptor");

		auto arc_tokens = vector<string>();
		boost::split(arc_tokens, line, boost::is_any_of(" \t"),
					 boost::token_compress_on);

		assert(arc_tokens.size() == 6);

		++no_of_edges;
		new_edge(no_of_edges, stoul(arc_tokens[1]), stoul(arc_tokens[2]));
	} while (getline(dimacs_file, line));
}

template <typename IntegerType, typename RationalType>
void Graph<IntegerType, RationalType>::initialize_internal_data_structures(
		int n, int m) {
	no_of_vertices = n;

	heads.resize(m + 1, 0);
	tails.resize(m + 1, 0);

	incident_edges.resize(n + 1);
}

/** \brief Create a new Edge
*
* Adds an arc between the given nodes and returns the arc_map
*
* @param node u
* @param node v
* @return arc
*/
template <typename IntegerType, typename RationalType>
arc Graph<IntegerType, RationalType>::new_edge(node u, node v) {
	no_of_edges++;
	heads.resize(no_of_edges + 1);
	tails.resize(no_of_edges + 1);
	return new_edge(no_of_edges, u, v);
}

/** \brief creates a new edge
*
* @param a Arc
* @param u node u
* @param v node v
*
* @return Returns the arc created
*
*/
template <typename IntegerType, typename RationalType>
arc Graph<IntegerType, RationalType>::new_edge(arc a, node u, node v) {
	assert(a > 0);
	assert(static_cast<unsigned int>(a) <= no_of_edges);

#ifdef VERBOSE
	cout << "new edge: no_of_edges " << no_of_edges << " = (" << u << "," << v
		 << ")" << endl;
#endif

	tails[a] = u;
	heads[a] = v;

	incident_edges[u].push_back(a);
	incident_edges[v].push_back(-a);

#ifdef VERBOSE
	cout << "tails[" << a << "]: " << u << endl;
	cout << "heads[" << a << "]: " << v << endl;
	cout << "incident edges[" << u << "] pushed back: " << a
		 << " length of incidentedges[" << u
		 << "]: " << incident_edges[u].size() << endl;
	cout << "incident edges[" << v << "] pushed back: " << -a
		 << " length of incidentedges[" << v
		 << "]: " << incident_edges[v].size() << endl;
#endif

	return a;
}
