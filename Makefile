ifeq ($(shell uname),Darwin)
	CC= clang++
	CCFLAGS = -Wall -g -std=c++11 -O3 -I /opt/local/include -DNDEBUG
else
	CC= g++
	CCFLAGS = -Wall -g -std=c++11 -O3 -DNDEBUG
endif


# hq: hybrid queue
# rbn: restore balanced nodes
# snas: always select the same start node
# snbal: select the same node until balanced, then the next node
# snbaldef: select the same node until balanced, then the node with the most absolute deficit
# def0: stop iteration if deficit_s reaches 0
# sc: stop iteration if the sign of deficit_s changes
# nsc: stop iteration if the sign of a new node is different to the sign of the start node
# def0_X/sc_X/nsc_X: every X iterations explore the entire graph
# gda: greedy dual ascent
# gdar: greedy dual ascent on the residual network


default: \
	min_cost_flow

all: \
	min_cost_flow \
	min_cost_flow_def0 \
	min_cost_flow_sc \
	min_cost_flow_nsc \
	min_cost_flow_gda \
	min_cost_flow_gda_def0 \
	min_cost_flow_gda_sc \
	min_cost_flow_gda_nsc \
	min_cost_flow_gda_aq \
	min_cost_flow_gda_aq_def0 \
	min_cost_flow_gda_aq_sc \
	min_cost_flow_gda_aq_nsc \
	min_cost_flow_gdar \
	min_cost_flow_gdar_def0 \
	min_cost_flow_gdar_sc \
	min_cost_flow_gdar_nsc \
	min_cost_flow_gdar_aq \
	min_cost_flow_gdar_aq_def0 \
	min_cost_flow_gdar_aq_sc \
	min_cost_flow_gdar_aq_nsc \
	min_cost_flow_scaling \
	min_cost_flow_scaling_def0 \
	min_cost_flow_scaling_sc \
	min_cost_flow_scaling_nsc \
	min_cost_flow_scaling_gda \
	min_cost_flow_scaling_gda_def0 \
	min_cost_flow_scaling_gda_sc \
	min_cost_flow_scaling_gda_nsc \
	min_cost_flow_scaling_gda_aq \
	min_cost_flow_scaling_gda_aq_def0 \
	min_cost_flow_scaling_gda_aq_sc \
	min_cost_flow_scaling_gda_aq_nsc \
	min_cost_flow_scaling_gdar \
	min_cost_flow_scaling_gdar_def0 \
	min_cost_flow_scaling_gdar_sc \
	min_cost_flow_scaling_gdar_nsc \
	min_cost_flow_scaling_gdar_aq \
	min_cost_flow_scaling_gdar_aq_def0 \
	min_cost_flow_scaling_gdar_aq_sc \
	min_cost_flow_scaling_gdar_aq_nsc \
	min_cost_flow_snas \
	min_cost_flow_snas_gda \
	min_cost_flow_snas_gda_aq \
	min_cost_flow_snas_gdar \
	min_cost_flow_snas_gdar_aq \
	min_cost_flow_snas_scaling \
	min_cost_flow_snas_scaling_gda \
	min_cost_flow_snas_scaling_gda_aq \
	min_cost_flow_snas_scaling_gdar \
	min_cost_flow_snas_scaling_gdar_aq \
	min_cost_flow_snbaldef \
	min_cost_flow_snbaldef_def0 \
	min_cost_flow_snbaldef_sc \
	min_cost_flow_snbaldef_nsc \
	min_cost_flow_snbaldef_gda \
	min_cost_flow_snbaldef_gda_def0 \
	min_cost_flow_snbaldef_gda_sc \
	min_cost_flow_snbaldef_gda_nsc \
	min_cost_flow_snbaldef_gda_aq \
	min_cost_flow_snbaldef_gda_aq_def0 \
	min_cost_flow_snbaldef_gda_aq_sc \
	min_cost_flow_snbaldef_gda_aq_nsc \
	min_cost_flow_snbaldef_gdar \
	min_cost_flow_snbaldef_gdar_def0 \
	min_cost_flow_snbaldef_gdar_sc \
	min_cost_flow_snbaldef_gdar_nsc \
	min_cost_flow_snbaldef_gdar_aq \
	min_cost_flow_snbaldef_gdar_aq_def0 \
	min_cost_flow_snbaldef_gdar_aq_sc \
	min_cost_flow_snbaldef_gdar_aq_nsc \
	min_cost_flow_snbaldef_scaling \
	min_cost_flow_snbaldef_scaling_def0 \
	min_cost_flow_snbaldef_scaling_sc \
	min_cost_flow_snbaldef_scaling_nsc \
	min_cost_flow_snbaldef_scaling_gda \
	min_cost_flow_snbaldef_scaling_gda_def0 \
	min_cost_flow_snbaldef_scaling_gda_sc \
	min_cost_flow_snbaldef_scaling_gda_nsc \
	min_cost_flow_snbaldef_scaling_gda_aq \
	min_cost_flow_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_snbaldef_scaling_gdar \
	min_cost_flow_snbaldef_scaling_gdar_def0 \
	min_cost_flow_snbaldef_scaling_gdar_sc \
	min_cost_flow_snbaldef_scaling_gdar_nsc \
	min_cost_flow_snbaldef_scaling_gdar_aq \
	min_cost_flow_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_snbaldef_scaling_gdar_aq_nsc \
	min_cost_flow_rbn \
	min_cost_flow_rbn_def0 \
	min_cost_flow_rbn_sc \
	min_cost_flow_rbn_nsc \
	min_cost_flow_rbn_gda \
	min_cost_flow_rbn_gda_def0 \
	min_cost_flow_rbn_gda_sc \
	min_cost_flow_rbn_gda_nsc \
	min_cost_flow_rbn_gda_aq \
	min_cost_flow_rbn_gda_aq_def0 \
	min_cost_flow_rbn_gda_aq_sc \
	min_cost_flow_rbn_gda_aq_nsc \
	min_cost_flow_rbn_gdar \
	min_cost_flow_rbn_gdar_def0 \
	min_cost_flow_rbn_gdar_sc \
	min_cost_flow_rbn_gdar_nsc \
	min_cost_flow_rbn_gdar_aq \
	min_cost_flow_rbn_gdar_aq_def0 \
	min_cost_flow_rbn_gdar_aq_sc \
	min_cost_flow_rbn_gdar_aq_nsc \
	min_cost_flow_rbn_scaling \
	min_cost_flow_rbn_scaling_def0 \
	min_cost_flow_rbn_scaling_sc \
	min_cost_flow_rbn_scaling_nsc \
	min_cost_flow_rbn_scaling_gda \
	min_cost_flow_rbn_scaling_gda_def0 \
	min_cost_flow_rbn_scaling_gda_sc \
	min_cost_flow_rbn_scaling_gda_nsc \
	min_cost_flow_rbn_scaling_gda_aq \
	min_cost_flow_rbn_scaling_gda_aq_def0 \
	min_cost_flow_rbn_scaling_gda_aq_sc \
	min_cost_flow_rbn_scaling_gda_aq_nsc \
	min_cost_flow_rbn_scaling_gdar \
	min_cost_flow_rbn_scaling_gdar_def0 \
	min_cost_flow_rbn_scaling_gdar_sc \
	min_cost_flow_rbn_scaling_gdar_nsc \
	min_cost_flow_rbn_scaling_gdar_aq \
	min_cost_flow_rbn_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_scaling_gdar_aq_sc \
	min_cost_flow_rbn_scaling_gdar_aq_nsc \
	min_cost_flow_rbn_snbal \
	min_cost_flow_rbn_snbal_def0 \
	min_cost_flow_rbn_snbal_sc \
	min_cost_flow_rbn_snbal_nsc \
	min_cost_flow_rbn_snbal_scaling \
	min_cost_flow_rbn_snbal_scaling_def0 \
	min_cost_flow_rbn_snbal_scaling_sc \
	min_cost_flow_rbn_snbal_scaling_nsc \
	min_cost_flow_rbn_snbaldef \
	min_cost_flow_rbn_snbaldef_def0 \
	min_cost_flow_rbn_snbaldef_sc \
	min_cost_flow_rbn_snbaldef_nsc \
	min_cost_flow_rbn_snbaldef_gda \
	min_cost_flow_rbn_snbaldef_gda_def0 \
	min_cost_flow_rbn_snbaldef_gda_sc \
	min_cost_flow_rbn_snbaldef_gda_nsc \
	min_cost_flow_rbn_snbaldef_gda_aq \
	min_cost_flow_rbn_snbaldef_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_gdar \
	min_cost_flow_rbn_snbaldef_gdar_def0 \
	min_cost_flow_rbn_snbaldef_gdar_sc \
	min_cost_flow_rbn_snbaldef_gdar_nsc \
	min_cost_flow_rbn_snbaldef_gdar_aq \
	min_cost_flow_rbn_snbaldef_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_gdar_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling \
	min_cost_flow_rbn_snbaldef_scaling_def0 \
	min_cost_flow_rbn_snbaldef_scaling_sc \
	min_cost_flow_rbn_snbaldef_scaling_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda \
	min_cost_flow_rbn_snbaldef_scaling_gda_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar \
	min_cost_flow_rbn_snbaldef_scaling_gdar_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_nsc \
	min_cost_flow_hq \
	min_cost_flow_hq_def0 \
	min_cost_flow_hq_sc \
	min_cost_flow_hq_nsc \
	min_cost_flow_hq_scaling \
	min_cost_flow_hq_scaling_def0 \
	min_cost_flow_hq_scaling_sc \
	min_cost_flow_hq_scaling_nsc \
	min_cost_flow_hq_snas \
	min_cost_flow_hq_snas_scaling \
	min_cost_flow_hq_snbaldef \
	min_cost_flow_hq_snbaldef_def0 \
	min_cost_flow_hq_snbaldef_sc \
	min_cost_flow_hq_snbaldef_nsc \
	min_cost_flow_hq_snbaldef_scaling \
	min_cost_flow_hq_snbaldef_scaling_def0 \
	min_cost_flow_hq_snbaldef_scaling_sc \
	min_cost_flow_hq_snbaldef_scaling_nsc \
	min_cost_flow_hq_rbn \
	min_cost_flow_hq_rbn_def0 \
	min_cost_flow_hq_rbn_sc \
	min_cost_flow_hq_rbn_nsc \
	min_cost_flow_hq_rbn_scaling \
	min_cost_flow_hq_rbn_scaling_def0 \
	min_cost_flow_hq_rbn_scaling_sc \
	min_cost_flow_hq_rbn_scaling_nsc \
	min_cost_flow_hq_rbn_snbal \
	min_cost_flow_hq_rbn_snbal_def0 \
	min_cost_flow_hq_rbn_snbal_sc \
	min_cost_flow_hq_rbn_snbal_nsc \
	min_cost_flow_hq_rbn_snbal_scaling \
	min_cost_flow_hq_rbn_snbal_scaling_def0 \
	min_cost_flow_hq_rbn_snbal_scaling_sc \
	min_cost_flow_hq_rbn_snbal_scaling_nsc \
	min_cost_flow_hq_rbn_snbaldef \
	min_cost_flow_hq_rbn_snbaldef_def0 \
	min_cost_flow_hq_rbn_snbaldef_sc \
	min_cost_flow_hq_rbn_snbaldef_nsc \
	min_cost_flow_hq_rbn_snbaldef_scaling \
	min_cost_flow_hq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hq_rbn_snbaldef_scaling_nsc \
	min_cost_flow_hvq \
	min_cost_flow_hvq_def0 \
	min_cost_flow_hvq_sc \
	min_cost_flow_hvq_nsc \
	min_cost_flow_hvq_scaling \
	min_cost_flow_hvq_scaling_def0 \
	min_cost_flow_hvq_scaling_sc \
	min_cost_flow_hvq_scaling_nsc \
	min_cost_flow_hvq_snas \
	min_cost_flow_hvq_snas_scaling \
	min_cost_flow_hvq_snbaldef \
	min_cost_flow_hvq_snbaldef_def0 \
	min_cost_flow_hvq_snbaldef_sc \
	min_cost_flow_hvq_snbaldef_nsc \
	min_cost_flow_hvq_snbaldef_scaling \
	min_cost_flow_hvq_snbaldef_scaling_def0 \
	min_cost_flow_hvq_snbaldef_scaling_sc \
	min_cost_flow_hvq_snbaldef_scaling_nsc \
	min_cost_flow_hvq_rbn \
	min_cost_flow_hvq_rbn_def0 \
	min_cost_flow_hvq_rbn_sc \
	min_cost_flow_hvq_rbn_nsc \
	min_cost_flow_hvq_rbn_scaling \
	min_cost_flow_hvq_rbn_scaling_def0 \
	min_cost_flow_hvq_rbn_scaling_sc \
	min_cost_flow_hvq_rbn_scaling_nsc \
	min_cost_flow_hvq_rbn_snbal \
	min_cost_flow_hvq_rbn_snbal_def0 \
	min_cost_flow_hvq_rbn_snbal_sc \
	min_cost_flow_hvq_rbn_snbal_nsc \
	min_cost_flow_hvq_rbn_snbal_scaling \
	min_cost_flow_hvq_rbn_snbal_scaling_def0 \
	min_cost_flow_hvq_rbn_snbal_scaling_sc \
	min_cost_flow_hvq_rbn_snbal_scaling_nsc \
	min_cost_flow_hvq_rbn_snbaldef \
	min_cost_flow_hvq_rbn_snbaldef_def0 \
	min_cost_flow_hvq_rbn_snbaldef_sc \
	min_cost_flow_hvq_rbn_snbaldef_nsc \
	min_cost_flow_hvq_rbn_snbaldef_scaling \
	min_cost_flow_hvq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hvq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hvq_rbn_snbaldef_scaling_nsc

standard_queue: \
	min_cost_flow \
	min_cost_flow_def0 \
	min_cost_flow_sc \
	min_cost_flow_nsc \
	min_cost_flow_gda \
	min_cost_flow_gda_def0 \
	min_cost_flow_gda_sc \
	min_cost_flow_gda_nsc \
	min_cost_flow_gda_aq \
	min_cost_flow_gda_aq_def0 \
	min_cost_flow_gda_aq_sc \
	min_cost_flow_gda_aq_nsc \
	min_cost_flow_gdar \
	min_cost_flow_gdar_def0 \
	min_cost_flow_gdar_sc \
	min_cost_flow_gdar_nsc \
	min_cost_flow_gdar_aq \
	min_cost_flow_gdar_aq_def0 \
	min_cost_flow_gdar_aq_sc \
	min_cost_flow_gdar_aq_nsc \
	min_cost_flow_scaling \
	min_cost_flow_scaling_def0 \
	min_cost_flow_scaling_sc \
	min_cost_flow_scaling_nsc \
	min_cost_flow_scaling_gda \
	min_cost_flow_scaling_gda_def0 \
	min_cost_flow_scaling_gda_sc \
	min_cost_flow_scaling_gda_nsc \
	min_cost_flow_scaling_gda_aq \
	min_cost_flow_scaling_gda_aq_def0 \
	min_cost_flow_scaling_gda_aq_sc \
	min_cost_flow_scaling_gda_aq_nsc \
	min_cost_flow_scaling_gdar \
	min_cost_flow_scaling_gdar_def0 \
	min_cost_flow_scaling_gdar_sc \
	min_cost_flow_scaling_gdar_nsc \
	min_cost_flow_scaling_gdar_aq \
	min_cost_flow_scaling_gdar_aq_def0 \
	min_cost_flow_scaling_gdar_aq_sc \
	min_cost_flow_scaling_gdar_aq_nsc \
	min_cost_flow_snas \
	min_cost_flow_snas_gda \
	min_cost_flow_snas_gda_aq \
	min_cost_flow_snas_gdar \
	min_cost_flow_snas_gdar_aq \
	min_cost_flow_snas_scaling \
	min_cost_flow_snas_scaling_gda \
	min_cost_flow_snas_scaling_gda_aq \
	min_cost_flow_snas_scaling_gdar \
	min_cost_flow_snas_scaling_gdar_aq \
	min_cost_flow_snbaldef \
	min_cost_flow_snbaldef_def0 \
	min_cost_flow_snbaldef_sc \
	min_cost_flow_snbaldef_nsc \
	min_cost_flow_snbaldef_gda \
	min_cost_flow_snbaldef_gda_def0 \
	min_cost_flow_snbaldef_gda_sc \
	min_cost_flow_snbaldef_gda_nsc \
	min_cost_flow_snbaldef_gda_aq \
	min_cost_flow_snbaldef_gda_aq_def0 \
	min_cost_flow_snbaldef_gda_aq_sc \
	min_cost_flow_snbaldef_gda_aq_nsc \
	min_cost_flow_snbaldef_gdar \
	min_cost_flow_snbaldef_gdar_def0 \
	min_cost_flow_snbaldef_gdar_sc \
	min_cost_flow_snbaldef_gdar_nsc \
	min_cost_flow_snbaldef_gdar_aq \
	min_cost_flow_snbaldef_gdar_aq_def0 \
	min_cost_flow_snbaldef_gdar_aq_sc \
	min_cost_flow_snbaldef_gdar_aq_nsc \
	min_cost_flow_snbaldef_scaling \
	min_cost_flow_snbaldef_scaling_def0 \
	min_cost_flow_snbaldef_scaling_sc \
	min_cost_flow_snbaldef_scaling_nsc \
	min_cost_flow_snbaldef_scaling_gda \
	min_cost_flow_snbaldef_scaling_gda_def0 \
	min_cost_flow_snbaldef_scaling_gda_sc \
	min_cost_flow_snbaldef_scaling_gda_nsc \
	min_cost_flow_snbaldef_scaling_gda_aq \
	min_cost_flow_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_snbaldef_scaling_gdar \
	min_cost_flow_snbaldef_scaling_gdar_def0 \
	min_cost_flow_snbaldef_scaling_gdar_sc \
	min_cost_flow_snbaldef_scaling_gdar_nsc \
	min_cost_flow_snbaldef_scaling_gdar_aq \
	min_cost_flow_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_snbaldef_scaling_gdar_aq_nsc \
	min_cost_flow_rbn \
	min_cost_flow_rbn_def0 \
	min_cost_flow_rbn_sc \
	min_cost_flow_rbn_nsc \
	min_cost_flow_rbn_gda \
	min_cost_flow_rbn_gda_def0 \
	min_cost_flow_rbn_gda_sc \
	min_cost_flow_rbn_gda_nsc \
	min_cost_flow_rbn_gda_aq \
	min_cost_flow_rbn_gda_aq_def0 \
	min_cost_flow_rbn_gda_aq_sc \
	min_cost_flow_rbn_gda_aq_nsc \
	min_cost_flow_rbn_gdar \
	min_cost_flow_rbn_gdar_def0 \
	min_cost_flow_rbn_gdar_sc \
	min_cost_flow_rbn_gdar_nsc \
	min_cost_flow_rbn_gdar_aq \
	min_cost_flow_rbn_gdar_aq_def0 \
	min_cost_flow_rbn_gdar_aq_sc \
	min_cost_flow_rbn_gdar_aq_nsc \
	min_cost_flow_rbn_scaling \
	min_cost_flow_rbn_scaling_def0 \
	min_cost_flow_rbn_scaling_sc \
	min_cost_flow_rbn_scaling_nsc \
	min_cost_flow_rbn_scaling_gda \
	min_cost_flow_rbn_scaling_gda_def0 \
	min_cost_flow_rbn_scaling_gda_sc \
	min_cost_flow_rbn_scaling_gda_nsc \
	min_cost_flow_rbn_scaling_gda_aq \
	min_cost_flow_rbn_scaling_gda_aq_def0 \
	min_cost_flow_rbn_scaling_gda_aq_sc \
	min_cost_flow_rbn_scaling_gda_aq_nsc \
	min_cost_flow_rbn_scaling_gdar \
	min_cost_flow_rbn_scaling_gdar_def0 \
	min_cost_flow_rbn_scaling_gdar_sc \
	min_cost_flow_rbn_scaling_gdar_nsc \
	min_cost_flow_rbn_scaling_gdar_aq \
	min_cost_flow_rbn_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_scaling_gdar_aq_sc \
	min_cost_flow_rbn_scaling_gdar_aq_nsc \
	min_cost_flow_rbn_snbal \
	min_cost_flow_rbn_snbal_def0 \
	min_cost_flow_rbn_snbal_sc \
	min_cost_flow_rbn_snbal_nsc \
	min_cost_flow_rbn_snbal_scaling \
	min_cost_flow_rbn_snbal_scaling_def0 \
	min_cost_flow_rbn_snbal_scaling_sc \
	min_cost_flow_rbn_snbal_scaling_nsc \
	min_cost_flow_rbn_snbaldef \
	min_cost_flow_rbn_snbaldef_def0 \
	min_cost_flow_rbn_snbaldef_sc \
	min_cost_flow_rbn_snbaldef_nsc \
	min_cost_flow_rbn_snbaldef_gda \
	min_cost_flow_rbn_snbaldef_gda_def0 \
	min_cost_flow_rbn_snbaldef_gda_sc \
	min_cost_flow_rbn_snbaldef_gda_nsc \
	min_cost_flow_rbn_snbaldef_gda_aq \
	min_cost_flow_rbn_snbaldef_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_gdar \
	min_cost_flow_rbn_snbaldef_gdar_def0 \
	min_cost_flow_rbn_snbaldef_gdar_sc \
	min_cost_flow_rbn_snbaldef_gdar_nsc \
	min_cost_flow_rbn_snbaldef_gdar_aq \
	min_cost_flow_rbn_snbaldef_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_gdar_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling \
	min_cost_flow_rbn_snbaldef_scaling_def0 \
	min_cost_flow_rbn_snbaldef_scaling_sc \
	min_cost_flow_rbn_snbaldef_scaling_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda \
	min_cost_flow_rbn_snbaldef_scaling_gda_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar \
	min_cost_flow_rbn_snbaldef_scaling_gdar_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_nsc

hybrid_queue: \
	min_cost_flow_hq \
	min_cost_flow_hq_def0 \
	min_cost_flow_hq_sc \
	min_cost_flow_hq_nsc \
	min_cost_flow_hq_scaling \
	min_cost_flow_hq_scaling_def0 \
	min_cost_flow_hq_scaling_sc \
	min_cost_flow_hq_scaling_nsc \
	min_cost_flow_hq_snas \
	min_cost_flow_hq_snas_scaling \
	min_cost_flow_hq_snbaldef \
	min_cost_flow_hq_snbaldef_def0 \
	min_cost_flow_hq_snbaldef_sc \
	min_cost_flow_hq_snbaldef_nsc \
	min_cost_flow_hq_snbaldef_scaling \
	min_cost_flow_hq_snbaldef_scaling_def0 \
	min_cost_flow_hq_snbaldef_scaling_sc \
	min_cost_flow_hq_snbaldef_scaling_nsc \
	min_cost_flow_hq_rbn \
	min_cost_flow_hq_rbn_def0 \
	min_cost_flow_hq_rbn_sc \
	min_cost_flow_hq_rbn_nsc \
	min_cost_flow_hq_rbn_scaling \
	min_cost_flow_hq_rbn_scaling_def0 \
	min_cost_flow_hq_rbn_scaling_sc \
	min_cost_flow_hq_rbn_scaling_nsc \
	min_cost_flow_hq_rbn_snbal \
	min_cost_flow_hq_rbn_snbal_def0 \
	min_cost_flow_hq_rbn_snbal_sc \
	min_cost_flow_hq_rbn_snbal_nsc \
	min_cost_flow_hq_rbn_snbal_scaling \
	min_cost_flow_hq_rbn_snbal_scaling_def0 \
	min_cost_flow_hq_rbn_snbal_scaling_sc \
	min_cost_flow_hq_rbn_snbal_scaling_nsc \
	min_cost_flow_hq_rbn_snbaldef \
	min_cost_flow_hq_rbn_snbaldef_def0 \
	min_cost_flow_hq_rbn_snbaldef_sc \
	min_cost_flow_hq_rbn_snbaldef_nsc \
	min_cost_flow_hq_rbn_snbaldef_scaling \
	min_cost_flow_hq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hq_rbn_snbaldef_scaling_nsc

hybrid_vector_queue: \
	min_cost_flow_hvq \
	min_cost_flow_hvq_def0 \
	min_cost_flow_hvq_sc \
	min_cost_flow_hvq_nsc \
	min_cost_flow_hvq_scaling \
	min_cost_flow_hvq_scaling_def0 \
	min_cost_flow_hvq_scaling_sc \
	min_cost_flow_hvq_scaling_nsc \
	min_cost_flow_hvq_snas \
	min_cost_flow_hvq_snas_scaling \
	min_cost_flow_hvq_snbaldef \
	min_cost_flow_hvq_snbaldef_def0 \
	min_cost_flow_hvq_snbaldef_sc \
	min_cost_flow_hvq_snbaldef_nsc \
	min_cost_flow_hvq_snbaldef_scaling \
	min_cost_flow_hvq_snbaldef_scaling_def0 \
	min_cost_flow_hvq_snbaldef_scaling_sc \
	min_cost_flow_hvq_snbaldef_scaling_nsc \
	min_cost_flow_hvq_rbn \
	min_cost_flow_hvq_rbn_def0 \
	min_cost_flow_hvq_rbn_sc \
	min_cost_flow_hvq_rbn_nsc \
	min_cost_flow_hvq_rbn_scaling \
	min_cost_flow_hvq_rbn_scaling_def0 \
	min_cost_flow_hvq_rbn_scaling_sc \
	min_cost_flow_hvq_rbn_scaling_nsc \
	min_cost_flow_hvq_rbn_snbal \
	min_cost_flow_hvq_rbn_snbal_def0 \
	min_cost_flow_hvq_rbn_snbal_sc \
	min_cost_flow_hvq_rbn_snbal_nsc \
	min_cost_flow_hvq_rbn_snbal_scaling \
	min_cost_flow_hvq_rbn_snbal_scaling_def0 \
	min_cost_flow_hvq_rbn_snbal_scaling_sc \
	min_cost_flow_hvq_rbn_snbal_scaling_nsc \
	min_cost_flow_hvq_rbn_snbaldef \
	min_cost_flow_hvq_rbn_snbaldef_def0 \
	min_cost_flow_hvq_rbn_snbaldef_sc \
	min_cost_flow_hvq_rbn_snbaldef_nsc \
	min_cost_flow_hvq_rbn_snbaldef_scaling \
	min_cost_flow_hvq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hvq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hvq_rbn_snbaldef_scaling_nsc

no_rbn: \
	min_cost_flow \
	min_cost_flow_def0 \
	min_cost_flow_sc \
	min_cost_flow_nsc \
	min_cost_flow_gda \
	min_cost_flow_gda_def0 \
	min_cost_flow_gda_sc \
	min_cost_flow_gda_nsc \
	min_cost_flow_gda_aq \
	min_cost_flow_gda_aq_def0 \
	min_cost_flow_gda_aq_sc \
	min_cost_flow_gda_aq_nsc \
	min_cost_flow_gdar \
	min_cost_flow_gdar_def0 \
	min_cost_flow_gdar_sc \
	min_cost_flow_gdar_nsc \
	min_cost_flow_gdar_aq \
	min_cost_flow_gdar_aq_def0 \
	min_cost_flow_gdar_aq_sc \
	min_cost_flow_gdar_aq_nsc \
	min_cost_flow_scaling \
	min_cost_flow_scaling_def0 \
	min_cost_flow_scaling_sc \
	min_cost_flow_scaling_nsc \
	min_cost_flow_scaling_gda \
	min_cost_flow_scaling_gda_def0 \
	min_cost_flow_scaling_gda_sc \
	min_cost_flow_scaling_gda_nsc \
	min_cost_flow_scaling_gda_aq \
	min_cost_flow_scaling_gda_aq_def0 \
	min_cost_flow_scaling_gda_aq_sc \
	min_cost_flow_scaling_gda_aq_nsc \
	min_cost_flow_scaling_gdar \
	min_cost_flow_scaling_gdar_def0 \
	min_cost_flow_scaling_gdar_sc \
	min_cost_flow_scaling_gdar_nsc \
	min_cost_flow_scaling_gdar_aq \
	min_cost_flow_scaling_gdar_aq_def0 \
	min_cost_flow_scaling_gdar_aq_sc \
	min_cost_flow_scaling_gdar_aq_nsc \
	min_cost_flow_snas \
	min_cost_flow_snas_gda \
	min_cost_flow_snas_gda_aq \
	min_cost_flow_snas_gdar \
	min_cost_flow_snas_gdar_aq \
	min_cost_flow_snas_scaling \
	min_cost_flow_snas_scaling_gda \
	min_cost_flow_snas_scaling_gda_aq \
	min_cost_flow_snas_scaling_gdar \
	min_cost_flow_snas_scaling_gdar_aq \
	min_cost_flow_snbaldef \
	min_cost_flow_snbaldef_def0 \
	min_cost_flow_snbaldef_sc \
	min_cost_flow_snbaldef_nsc \
	min_cost_flow_snbaldef_gda \
	min_cost_flow_snbaldef_gda_def0 \
	min_cost_flow_snbaldef_gda_sc \
	min_cost_flow_snbaldef_gda_nsc \
	min_cost_flow_snbaldef_gda_aq \
	min_cost_flow_snbaldef_gda_aq_def0 \
	min_cost_flow_snbaldef_gda_aq_sc \
	min_cost_flow_snbaldef_gda_aq_nsc \
	min_cost_flow_snbaldef_gdar \
	min_cost_flow_snbaldef_gdar_def0 \
	min_cost_flow_snbaldef_gdar_sc \
	min_cost_flow_snbaldef_gdar_nsc \
	min_cost_flow_snbaldef_gdar_aq \
	min_cost_flow_snbaldef_gdar_aq_def0 \
	min_cost_flow_snbaldef_gdar_aq_sc \
	min_cost_flow_snbaldef_gdar_aq_nsc \
	min_cost_flow_snbaldef_scaling \
	min_cost_flow_snbaldef_scaling_def0 \
	min_cost_flow_snbaldef_scaling_sc \
	min_cost_flow_snbaldef_scaling_nsc \
	min_cost_flow_snbaldef_scaling_gda \
	min_cost_flow_snbaldef_scaling_gda_def0 \
	min_cost_flow_snbaldef_scaling_gda_sc \
	min_cost_flow_snbaldef_scaling_gda_nsc \
	min_cost_flow_snbaldef_scaling_gda_aq \
	min_cost_flow_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_snbaldef_scaling_gdar \
	min_cost_flow_snbaldef_scaling_gdar_def0 \
	min_cost_flow_snbaldef_scaling_gdar_sc \
	min_cost_flow_snbaldef_scaling_gdar_nsc \
	min_cost_flow_snbaldef_scaling_gdar_aq \
	min_cost_flow_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_snbaldef_scaling_gdar_aq_nsc \
	min_cost_flow_hq \
	min_cost_flow_hq_def0 \
	min_cost_flow_hq_sc \
	min_cost_flow_hq_nsc \
	min_cost_flow_hq_scaling \
	min_cost_flow_hq_scaling_def0 \
	min_cost_flow_hq_scaling_sc \
	min_cost_flow_hq_scaling_nsc \
	min_cost_flow_hq_snas \
	min_cost_flow_hq_snas_scaling \
	min_cost_flow_hq_snbaldef \
	min_cost_flow_hq_snbaldef_def0 \
	min_cost_flow_hq_snbaldef_sc \
	min_cost_flow_hq_snbaldef_nsc \
	min_cost_flow_hq_snbaldef_scaling \
	min_cost_flow_hq_snbaldef_scaling_def0 \
	min_cost_flow_hq_snbaldef_scaling_sc \
	min_cost_flow_hq_snbaldef_scaling_nsc \
	min_cost_flow_hvq \
	min_cost_flow_hvq_def0 \
	min_cost_flow_hvq_sc \
	min_cost_flow_hvq_nsc \
	min_cost_flow_hvq_scaling \
	min_cost_flow_hvq_scaling_def0 \
	min_cost_flow_hvq_scaling_sc \
	min_cost_flow_hvq_scaling_nsc \
	min_cost_flow_hvq_snas \
	min_cost_flow_hvq_snas_scaling \
	min_cost_flow_hvq_snbaldef \
	min_cost_flow_hvq_snbaldef_def0 \
	min_cost_flow_hvq_snbaldef_sc \
	min_cost_flow_hvq_snbaldef_nsc \
	min_cost_flow_hvq_snbaldef_scaling \
	min_cost_flow_hvq_snbaldef_scaling_def0 \
	min_cost_flow_hvq_snbaldef_scaling_sc \
	min_cost_flow_hvq_snbaldef_scaling_nsc

rbn: \
	min_cost_flow_rbn \
	min_cost_flow_rbn_def0 \
	min_cost_flow_rbn_sc \
	min_cost_flow_rbn_nsc \
	min_cost_flow_rbn_gda \
	min_cost_flow_rbn_gda_def0 \
	min_cost_flow_rbn_gda_sc \
	min_cost_flow_rbn_gda_nsc \
	min_cost_flow_rbn_gda_aq \
	min_cost_flow_rbn_gda_aq_def0 \
	min_cost_flow_rbn_gda_aq_sc \
	min_cost_flow_rbn_gda_aq_nsc \
	min_cost_flow_rbn_gdar \
	min_cost_flow_rbn_gdar_def0 \
	min_cost_flow_rbn_gdar_sc \
	min_cost_flow_rbn_gdar_nsc \
	min_cost_flow_rbn_gdar_aq \
	min_cost_flow_rbn_gdar_aq_def0 \
	min_cost_flow_rbn_gdar_aq_sc \
	min_cost_flow_rbn_gdar_aq_nsc \
	min_cost_flow_rbn_scaling \
	min_cost_flow_rbn_scaling_def0 \
	min_cost_flow_rbn_scaling_sc \
	min_cost_flow_rbn_scaling_nsc \
	min_cost_flow_rbn_scaling_gda \
	min_cost_flow_rbn_scaling_gda_def0 \
	min_cost_flow_rbn_scaling_gda_sc \
	min_cost_flow_rbn_scaling_gda_nsc \
	min_cost_flow_rbn_scaling_gda_aq \
	min_cost_flow_rbn_scaling_gda_aq_def0 \
	min_cost_flow_rbn_scaling_gda_aq_sc \
	min_cost_flow_rbn_scaling_gda_aq_nsc \
	min_cost_flow_rbn_scaling_gdar \
	min_cost_flow_rbn_scaling_gdar_def0 \
	min_cost_flow_rbn_scaling_gdar_sc \
	min_cost_flow_rbn_scaling_gdar_nsc \
	min_cost_flow_rbn_scaling_gdar_aq \
	min_cost_flow_rbn_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_scaling_gdar_aq_sc \
	min_cost_flow_rbn_scaling_gdar_aq_nsc \
	min_cost_flow_rbn_snbal \
	min_cost_flow_rbn_snbal_def0 \
	min_cost_flow_rbn_snbal_sc \
	min_cost_flow_rbn_snbal_nsc \
	min_cost_flow_rbn_snbal_scaling \
	min_cost_flow_rbn_snbal_scaling_def0 \
	min_cost_flow_rbn_snbal_scaling_sc \
	min_cost_flow_rbn_snbal_scaling_nsc \
	min_cost_flow_rbn_snbaldef \
	min_cost_flow_rbn_snbaldef_def0 \
	min_cost_flow_rbn_snbaldef_sc \
	min_cost_flow_rbn_snbaldef_nsc \
	min_cost_flow_rbn_snbaldef_gda \
	min_cost_flow_rbn_snbaldef_gda_def0 \
	min_cost_flow_rbn_snbaldef_gda_sc \
	min_cost_flow_rbn_snbaldef_gda_nsc \
	min_cost_flow_rbn_snbaldef_gda_aq \
	min_cost_flow_rbn_snbaldef_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_gdar \
	min_cost_flow_rbn_snbaldef_gdar_def0 \
	min_cost_flow_rbn_snbaldef_gdar_sc \
	min_cost_flow_rbn_snbaldef_gdar_nsc \
	min_cost_flow_rbn_snbaldef_gdar_aq \
	min_cost_flow_rbn_snbaldef_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_gdar_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling \
	min_cost_flow_rbn_snbaldef_scaling_def0 \
	min_cost_flow_rbn_snbaldef_scaling_sc \
	min_cost_flow_rbn_snbaldef_scaling_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda \
	min_cost_flow_rbn_snbaldef_scaling_gda_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar \
	min_cost_flow_rbn_snbaldef_scaling_gdar_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_nsc \
	min_cost_flow_hq_rbn \
	min_cost_flow_hq_rbn_def0 \
	min_cost_flow_hq_rbn_sc \
	min_cost_flow_hq_rbn_nsc \
	min_cost_flow_hq_rbn_scaling \
	min_cost_flow_hq_rbn_scaling_def0 \
	min_cost_flow_hq_rbn_scaling_sc \
	min_cost_flow_hq_rbn_scaling_nsc \
	min_cost_flow_hq_rbn_snbal \
	min_cost_flow_hq_rbn_snbal_def0 \
	min_cost_flow_hq_rbn_snbal_sc \
	min_cost_flow_hq_rbn_snbal_nsc \
	min_cost_flow_hq_rbn_snbal_scaling \
	min_cost_flow_hq_rbn_snbal_scaling_def0 \
	min_cost_flow_hq_rbn_snbal_scaling_sc \
	min_cost_flow_hq_rbn_snbal_scaling_nsc \
	min_cost_flow_hq_rbn_snbaldef \
	min_cost_flow_hq_rbn_snbaldef_def0 \
	min_cost_flow_hq_rbn_snbaldef_sc \
	min_cost_flow_hq_rbn_snbaldef_nsc \
	min_cost_flow_hq_rbn_snbaldef_scaling \
	min_cost_flow_hq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hq_rbn_snbaldef_scaling_nsc \
	min_cost_flow_hvq_rbn \
	min_cost_flow_hvq_rbn_def0 \
	min_cost_flow_hvq_rbn_sc \
	min_cost_flow_hvq_rbn_nsc \
	min_cost_flow_hvq_rbn_scaling \
	min_cost_flow_hvq_rbn_scaling_def0 \
	min_cost_flow_hvq_rbn_scaling_sc \
	min_cost_flow_hvq_rbn_scaling_nsc \
	min_cost_flow_hvq_rbn_snbal \
	min_cost_flow_hvq_rbn_snbal_def0 \
	min_cost_flow_hvq_rbn_snbal_sc \
	min_cost_flow_hvq_rbn_snbal_nsc \
	min_cost_flow_hvq_rbn_snbal_scaling \
	min_cost_flow_hvq_rbn_snbal_scaling_def0 \
	min_cost_flow_hvq_rbn_snbal_scaling_sc \
	min_cost_flow_hvq_rbn_snbal_scaling_nsc \
	min_cost_flow_hvq_rbn_snbaldef \
	min_cost_flow_hvq_rbn_snbaldef_def0 \
	min_cost_flow_hvq_rbn_snbaldef_sc \
	min_cost_flow_hvq_rbn_snbaldef_nsc \
	min_cost_flow_hvq_rbn_snbaldef_scaling \
	min_cost_flow_hvq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hvq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hvq_rbn_snbaldef_scaling_nsc

no_rbn_standard_queue: \
	min_cost_flow \
	min_cost_flow_def0 \
	min_cost_flow_sc \
	min_cost_flow_nsc \
	min_cost_flow_gda \
	min_cost_flow_gda_def0 \
	min_cost_flow_gda_sc \
	min_cost_flow_gda_nsc \
	min_cost_flow_gda_aq \
	min_cost_flow_gda_aq_def0 \
	min_cost_flow_gda_aq_sc \
	min_cost_flow_gda_aq_nsc \
	min_cost_flow_gdar \
	min_cost_flow_gdar_def0 \
	min_cost_flow_gdar_sc \
	min_cost_flow_gdar_nsc \
	min_cost_flow_gdar_aq \
	min_cost_flow_gdar_aq_def0 \
	min_cost_flow_gdar_aq_sc \
	min_cost_flow_gdar_aq_nsc \
	min_cost_flow_scaling \
	min_cost_flow_scaling_def0 \
	min_cost_flow_scaling_sc \
	min_cost_flow_scaling_nsc \
	min_cost_flow_scaling_gda \
	min_cost_flow_scaling_gda_def0 \
	min_cost_flow_scaling_gda_sc \
	min_cost_flow_scaling_gda_nsc \
	min_cost_flow_scaling_gda_aq \
	min_cost_flow_scaling_gda_aq_def0 \
	min_cost_flow_scaling_gda_aq_sc \
	min_cost_flow_scaling_gda_aq_nsc \
	min_cost_flow_scaling_gdar \
	min_cost_flow_scaling_gdar_def0 \
	min_cost_flow_scaling_gdar_sc \
	min_cost_flow_scaling_gdar_nsc \
	min_cost_flow_scaling_gdar_aq \
	min_cost_flow_scaling_gdar_aq_def0 \
	min_cost_flow_scaling_gdar_aq_sc \
	min_cost_flow_scaling_gdar_aq_nsc \
	min_cost_flow_snas \
	min_cost_flow_snas_gda \
	min_cost_flow_snas_gda_aq \
	min_cost_flow_snas_gdar \
	min_cost_flow_snas_gdar_aq \
	min_cost_flow_snas_scaling \
	min_cost_flow_snas_scaling_gda \
	min_cost_flow_snas_scaling_gda_aq \
	min_cost_flow_snas_scaling_gdar \
	min_cost_flow_snas_scaling_gdar_aq \
	min_cost_flow_snbaldef \
	min_cost_flow_snbaldef_def0 \
	min_cost_flow_snbaldef_sc \
	min_cost_flow_snbaldef_nsc \
	min_cost_flow_snbaldef_gda \
	min_cost_flow_snbaldef_gda_def0 \
	min_cost_flow_snbaldef_gda_sc \
	min_cost_flow_snbaldef_gda_nsc \
	min_cost_flow_snbaldef_gda_aq \
	min_cost_flow_snbaldef_gda_aq_def0 \
	min_cost_flow_snbaldef_gda_aq_sc \
	min_cost_flow_snbaldef_gda_aq_nsc \
	min_cost_flow_snbaldef_gdar \
	min_cost_flow_snbaldef_gdar_def0 \
	min_cost_flow_snbaldef_gdar_sc \
	min_cost_flow_snbaldef_gdar_nsc \
	min_cost_flow_snbaldef_gdar_aq \
	min_cost_flow_snbaldef_gdar_aq_def0 \
	min_cost_flow_snbaldef_gdar_aq_sc \
	min_cost_flow_snbaldef_gdar_aq_nsc \
	min_cost_flow_snbaldef_scaling \
	min_cost_flow_snbaldef_scaling_def0 \
	min_cost_flow_snbaldef_scaling_sc \
	min_cost_flow_snbaldef_scaling_nsc \
	min_cost_flow_snbaldef_scaling_gda \
	min_cost_flow_snbaldef_scaling_gda_def0 \
	min_cost_flow_snbaldef_scaling_gda_sc \
	min_cost_flow_snbaldef_scaling_gda_nsc \
	min_cost_flow_snbaldef_scaling_gda_aq \
	min_cost_flow_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_snbaldef_scaling_gdar \
	min_cost_flow_snbaldef_scaling_gdar_def0 \
	min_cost_flow_snbaldef_scaling_gdar_sc \
	min_cost_flow_snbaldef_scaling_gdar_nsc \
	min_cost_flow_snbaldef_scaling_gdar_aq \
	min_cost_flow_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_snbaldef_scaling_gdar_aq_nsc

scaling: \
	min_cost_flow_scaling \
	min_cost_flow_scaling_def0 \
	min_cost_flow_scaling_sc \
	min_cost_flow_scaling_nsc \
	min_cost_flow_scaling_gda \
	min_cost_flow_scaling_gda_def0 \
	min_cost_flow_scaling_gda_sc \
	min_cost_flow_scaling_gda_nsc \
	min_cost_flow_scaling_gda_aq \
	min_cost_flow_scaling_gda_aq_def0 \
	min_cost_flow_scaling_gda_aq_sc \
	min_cost_flow_scaling_gda_aq_nsc \
	min_cost_flow_scaling_gdar \
	min_cost_flow_scaling_gdar_def0 \
	min_cost_flow_scaling_gdar_sc \
	min_cost_flow_scaling_gdar_nsc \
	min_cost_flow_scaling_gdar_aq \
	min_cost_flow_scaling_gdar_aq_def0 \
	min_cost_flow_scaling_gdar_aq_sc \
	min_cost_flow_scaling_gdar_aq_nsc \
	min_cost_flow_snas_scaling \
	min_cost_flow_snas_scaling_gda \
	min_cost_flow_snas_scaling_gda_aq \
	min_cost_flow_snas_scaling_gdar \
	min_cost_flow_snas_scaling_gdar_aq \
	min_cost_flow_snbaldef_scaling \
	min_cost_flow_snbaldef_scaling_def0 \
	min_cost_flow_snbaldef_scaling_sc \
	min_cost_flow_snbaldef_scaling_nsc \
	min_cost_flow_snbaldef_scaling_gda \
	min_cost_flow_snbaldef_scaling_gda_def0 \
	min_cost_flow_snbaldef_scaling_gda_sc \
	min_cost_flow_snbaldef_scaling_gda_nsc \
	min_cost_flow_snbaldef_scaling_gda_aq \
	min_cost_flow_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_snbaldef_scaling_gdar \
	min_cost_flow_snbaldef_scaling_gdar_def0 \
	min_cost_flow_snbaldef_scaling_gdar_sc \
	min_cost_flow_snbaldef_scaling_gdar_nsc \
	min_cost_flow_snbaldef_scaling_gdar_aq \
	min_cost_flow_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_snbaldef_scaling_gdar_aq_nsc \
	min_cost_flow_rbn_scaling \
	min_cost_flow_rbn_scaling_def0 \
	min_cost_flow_rbn_scaling_sc \
	min_cost_flow_rbn_scaling_nsc \
	min_cost_flow_rbn_scaling_gda \
	min_cost_flow_rbn_scaling_gda_def0 \
	min_cost_flow_rbn_scaling_gda_sc \
	min_cost_flow_rbn_scaling_gda_nsc \
	min_cost_flow_rbn_scaling_gda_aq \
	min_cost_flow_rbn_scaling_gda_aq_def0 \
	min_cost_flow_rbn_scaling_gda_aq_sc \
	min_cost_flow_rbn_scaling_gda_aq_nsc \
	min_cost_flow_rbn_scaling_gdar \
	min_cost_flow_rbn_scaling_gdar_def0 \
	min_cost_flow_rbn_scaling_gdar_sc \
	min_cost_flow_rbn_scaling_gdar_nsc \
	min_cost_flow_rbn_scaling_gdar_aq \
	min_cost_flow_rbn_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_scaling_gdar_aq_sc \
	min_cost_flow_rbn_scaling_gdar_aq_nsc \
	min_cost_flow_rbn_snbal_scaling \
	min_cost_flow_rbn_snbal_scaling_def0 \
	min_cost_flow_rbn_snbal_scaling_sc \
	min_cost_flow_rbn_snbal_scaling_nsc \
	min_cost_flow_rbn_snbaldef_scaling \
	min_cost_flow_rbn_snbaldef_scaling_def0 \
	min_cost_flow_rbn_snbaldef_scaling_sc \
	min_cost_flow_rbn_snbaldef_scaling_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda \
	min_cost_flow_rbn_snbaldef_scaling_gda_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar \
	min_cost_flow_rbn_snbaldef_scaling_gdar_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_nsc \
	min_cost_flow_hq_scaling \
	min_cost_flow_hq_scaling_def0 \
	min_cost_flow_hq_scaling_sc \
	min_cost_flow_hq_scaling_nsc \
	min_cost_flow_hq_snas_scaling \
	min_cost_flow_hq_snbaldef_scaling \
	min_cost_flow_hq_snbaldef_scaling_def0 \
	min_cost_flow_hq_snbaldef_scaling_sc \
	min_cost_flow_hq_snbaldef_scaling_nsc \
	min_cost_flow_hq_rbn_scaling \
	min_cost_flow_hq_rbn_scaling_def0 \
	min_cost_flow_hq_rbn_scaling_sc \
	min_cost_flow_hq_rbn_scaling_nsc \
	min_cost_flow_hq_rbn_snbal_scaling \
	min_cost_flow_hq_rbn_snbal_scaling_def0 \
	min_cost_flow_hq_rbn_snbal_scaling_sc \
	min_cost_flow_hq_rbn_snbal_scaling_nsc \
	min_cost_flow_hq_rbn_snbaldef_scaling \
	min_cost_flow_hq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hq_rbn_snbaldef_scaling_nsc \
	min_cost_flow_hvq_scaling \
	min_cost_flow_hvq_scaling_def0 \
	min_cost_flow_hvq_scaling_sc \
	min_cost_flow_hvq_scaling_nsc \
	min_cost_flow_hvq_snas_scaling \
	min_cost_flow_hvq_snbaldef_scaling \
	min_cost_flow_hvq_snbaldef_scaling_def0 \
	min_cost_flow_hvq_snbaldef_scaling_sc \
	min_cost_flow_hvq_snbaldef_scaling_nsc \
	min_cost_flow_hvq_rbn_scaling \
	min_cost_flow_hvq_rbn_scaling_def0 \
	min_cost_flow_hvq_rbn_scaling_sc \
	min_cost_flow_hvq_rbn_scaling_nsc \
	min_cost_flow_hvq_rbn_snbal_scaling \
	min_cost_flow_hvq_rbn_snbal_scaling_def0 \
	min_cost_flow_hvq_rbn_snbal_scaling_sc \
	min_cost_flow_hvq_rbn_snbal_scaling_nsc \
	min_cost_flow_hvq_rbn_snbaldef_scaling \
	min_cost_flow_hvq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hvq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hvq_rbn_snbaldef_scaling_nsc \

gda: \
	min_cost_flow_gda \
	min_cost_flow_gda_def0 \
	min_cost_flow_gda_sc \
	min_cost_flow_gda_nsc \
	min_cost_flow_gda_aq \
	min_cost_flow_gda_aq_def0 \
	min_cost_flow_gda_aq_sc \
	min_cost_flow_gda_aq_nsc \
	min_cost_flow_gdar \
	min_cost_flow_gdar_def0 \
	min_cost_flow_gdar_sc \
	min_cost_flow_gdar_nsc \
	min_cost_flow_gdar_aq \
	min_cost_flow_gdar_aq_def0 \
	min_cost_flow_gdar_aq_sc \
	min_cost_flow_gdar_aq_nsc \
	min_cost_flow_scaling_gda \
	min_cost_flow_scaling_gda_def0 \
	min_cost_flow_scaling_gda_sc \
	min_cost_flow_scaling_gda_nsc \
	min_cost_flow_scaling_gda_aq \
	min_cost_flow_scaling_gda_aq_def0 \
	min_cost_flow_scaling_gda_aq_sc \
	min_cost_flow_scaling_gda_aq_nsc \
	min_cost_flow_scaling_gdar \
	min_cost_flow_scaling_gdar_def0 \
	min_cost_flow_scaling_gdar_sc \
	min_cost_flow_scaling_gdar_nsc \
	min_cost_flow_scaling_gdar_aq \
	min_cost_flow_scaling_gdar_aq_def0 \
	min_cost_flow_scaling_gdar_aq_sc \
	min_cost_flow_scaling_gdar_aq_nsc \
	min_cost_flow_snas_gda \
	min_cost_flow_snas_gda_aq \
	min_cost_flow_snas_gdar \
	min_cost_flow_snas_gdar_aq \
	min_cost_flow_snas_scaling_gda \
	min_cost_flow_snas_scaling_gda_aq \
	min_cost_flow_snas_scaling_gdar \
	min_cost_flow_snas_scaling_gdar_aq \
	min_cost_flow_snbaldef_gda \
	min_cost_flow_snbaldef_gda_def0 \
	min_cost_flow_snbaldef_gda_sc \
	min_cost_flow_snbaldef_gda_nsc \
	min_cost_flow_snbaldef_gda_aq \
	min_cost_flow_snbaldef_gda_aq_def0 \
	min_cost_flow_snbaldef_gda_aq_sc \
	min_cost_flow_snbaldef_gda_aq_nsc \
	min_cost_flow_snbaldef_gdar \
	min_cost_flow_snbaldef_gdar_def0 \
	min_cost_flow_snbaldef_gdar_sc \
	min_cost_flow_snbaldef_gdar_nsc \
	min_cost_flow_snbaldef_gdar_aq \
	min_cost_flow_snbaldef_gdar_aq_def0 \
	min_cost_flow_snbaldef_gdar_aq_sc \
	min_cost_flow_snbaldef_gdar_aq_nsc \
	min_cost_flow_snbaldef_scaling_gda \
	min_cost_flow_snbaldef_scaling_gda_def0 \
	min_cost_flow_snbaldef_scaling_gda_sc \
	min_cost_flow_snbaldef_scaling_gda_nsc \
	min_cost_flow_snbaldef_scaling_gda_aq \
	min_cost_flow_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_snbaldef_scaling_gdar \
	min_cost_flow_snbaldef_scaling_gdar_def0 \
	min_cost_flow_snbaldef_scaling_gdar_sc \
	min_cost_flow_snbaldef_scaling_gdar_nsc \
	min_cost_flow_snbaldef_scaling_gdar_aq \
	min_cost_flow_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_snbaldef_scaling_gdar_aq_nsc \
	min_cost_flow_rbn_gda \
	min_cost_flow_rbn_gda_def0 \
	min_cost_flow_rbn_gda_sc \
	min_cost_flow_rbn_gda_nsc \
	min_cost_flow_rbn_gda_aq \
	min_cost_flow_rbn_gda_aq_def0 \
	min_cost_flow_rbn_gda_aq_sc \
	min_cost_flow_rbn_gda_aq_nsc \
	min_cost_flow_rbn_gdar \
	min_cost_flow_rbn_gdar_def0 \
	min_cost_flow_rbn_gdar_sc \
	min_cost_flow_rbn_gdar_nsc \
	min_cost_flow_rbn_gdar_aq \
	min_cost_flow_rbn_gdar_aq_def0 \
	min_cost_flow_rbn_gdar_aq_sc \
	min_cost_flow_rbn_gdar_aq_nsc \
	min_cost_flow_rbn_scaling_gda \
	min_cost_flow_rbn_scaling_gda_def0 \
	min_cost_flow_rbn_scaling_gda_sc \
	min_cost_flow_rbn_scaling_gda_nsc \
	min_cost_flow_rbn_scaling_gda_aq \
	min_cost_flow_rbn_scaling_gda_aq_def0 \
	min_cost_flow_rbn_scaling_gda_aq_sc \
	min_cost_flow_rbn_scaling_gda_aq_nsc \
	min_cost_flow_rbn_scaling_gdar \
	min_cost_flow_rbn_scaling_gdar_def0 \
	min_cost_flow_rbn_scaling_gdar_sc \
	min_cost_flow_rbn_scaling_gdar_nsc \
	min_cost_flow_rbn_scaling_gdar_aq \
	min_cost_flow_rbn_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_scaling_gdar_aq_sc \
	min_cost_flow_rbn_scaling_gdar_aq_nsc \
	min_cost_flow_rbn_snbaldef_gda \
	min_cost_flow_rbn_snbaldef_gda_def0 \
	min_cost_flow_rbn_snbaldef_gda_sc \
	min_cost_flow_rbn_snbaldef_gda_nsc \
	min_cost_flow_rbn_snbaldef_gda_aq \
	min_cost_flow_rbn_snbaldef_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_gdar \
	min_cost_flow_rbn_snbaldef_gdar_def0 \
	min_cost_flow_rbn_snbaldef_gdar_sc \
	min_cost_flow_rbn_snbaldef_gdar_nsc \
	min_cost_flow_rbn_snbaldef_gdar_aq \
	min_cost_flow_rbn_snbaldef_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_gdar_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda \
	min_cost_flow_rbn_snbaldef_scaling_gda_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gda_aq_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar \
	min_cost_flow_rbn_snbaldef_scaling_gdar_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_nsc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_def0 \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_sc \
	min_cost_flow_rbn_snbaldef_scaling_gdar_aq_nsc

no_gda: \
	min_cost_flow \
	min_cost_flow_def0 \
	min_cost_flow_sc \
	min_cost_flow_nsc \
	min_cost_flow_scaling \
	min_cost_flow_scaling_def0 \
	min_cost_flow_scaling_sc \
	min_cost_flow_scaling_nsc \
	min_cost_flow_snas \
	min_cost_flow_snas_scaling \
	min_cost_flow_snbaldef \
	min_cost_flow_snbaldef_def0 \
	min_cost_flow_snbaldef_sc \
	min_cost_flow_snbaldef_nsc \
	min_cost_flow_snbaldef_scaling \
	min_cost_flow_snbaldef_scaling_def0 \
	min_cost_flow_snbaldef_scaling_sc \
	min_cost_flow_snbaldef_scaling_nsc \
	min_cost_flow_rbn \
	min_cost_flow_rbn_def0 \
	min_cost_flow_rbn_sc \
	min_cost_flow_rbn_nsc \
	min_cost_flow_rbn_scaling \
	min_cost_flow_rbn_scaling_def0 \
	min_cost_flow_rbn_scaling_sc \
	min_cost_flow_rbn_scaling_nsc \
	min_cost_flow_rbn_snbal \
	min_cost_flow_rbn_snbal_def0 \
	min_cost_flow_rbn_snbal_sc \
	min_cost_flow_rbn_snbal_nsc \
	min_cost_flow_rbn_snbal_scaling \
	min_cost_flow_rbn_snbal_scaling_def0 \
	min_cost_flow_rbn_snbal_scaling_sc \
	min_cost_flow_rbn_snbal_scaling_nsc \
	min_cost_flow_rbn_snbaldef \
	min_cost_flow_rbn_snbaldef_def0 \
	min_cost_flow_rbn_snbaldef_sc \
	min_cost_flow_rbn_snbaldef_nsc \
	min_cost_flow_rbn_snbaldef_scaling \
	min_cost_flow_rbn_snbaldef_scaling_def0 \
	min_cost_flow_rbn_snbaldef_scaling_sc \
	min_cost_flow_rbn_snbaldef_scaling_nsc \
	min_cost_flow_hq \
	min_cost_flow_hq_def0 \
	min_cost_flow_hq_sc \
	min_cost_flow_hq_nsc \
	min_cost_flow_hq_scaling \
	min_cost_flow_hq_scaling_def0 \
	min_cost_flow_hq_scaling_sc \
	min_cost_flow_hq_scaling_nsc \
	min_cost_flow_hq_snas \
	min_cost_flow_hq_snas_scaling \
	min_cost_flow_hq_snbaldef \
	min_cost_flow_hq_snbaldef_def0 \
	min_cost_flow_hq_snbaldef_sc \
	min_cost_flow_hq_snbaldef_nsc \
	min_cost_flow_hq_snbaldef_scaling \
	min_cost_flow_hq_snbaldef_scaling_def0 \
	min_cost_flow_hq_snbaldef_scaling_sc \
	min_cost_flow_hq_snbaldef_scaling_nsc \
	min_cost_flow_hq_rbn \
	min_cost_flow_hq_rbn_def0 \
	min_cost_flow_hq_rbn_sc \
	min_cost_flow_hq_rbn_nsc \
	min_cost_flow_hq_rbn_scaling \
	min_cost_flow_hq_rbn_scaling_def0 \
	min_cost_flow_hq_rbn_scaling_sc \
	min_cost_flow_hq_rbn_scaling_nsc \
	min_cost_flow_hq_rbn_snbal \
	min_cost_flow_hq_rbn_snbal_def0 \
	min_cost_flow_hq_rbn_snbal_sc \
	min_cost_flow_hq_rbn_snbal_nsc \
	min_cost_flow_hq_rbn_snbal_scaling \
	min_cost_flow_hq_rbn_snbal_scaling_def0 \
	min_cost_flow_hq_rbn_snbal_scaling_sc \
	min_cost_flow_hq_rbn_snbal_scaling_nsc \
	min_cost_flow_hq_rbn_snbaldef \
	min_cost_flow_hq_rbn_snbaldef_def0 \
	min_cost_flow_hq_rbn_snbaldef_sc \
	min_cost_flow_hq_rbn_snbaldef_nsc \
	min_cost_flow_hq_rbn_snbaldef_scaling \
	min_cost_flow_hq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hq_rbn_snbaldef_scaling_nsc \
	min_cost_flow_hvq \
	min_cost_flow_hvq_def0 \
	min_cost_flow_hvq_sc \
	min_cost_flow_hvq_nsc \
	min_cost_flow_hvq_scaling \
	min_cost_flow_hvq_scaling_def0 \
	min_cost_flow_hvq_scaling_sc \
	min_cost_flow_hvq_scaling_nsc \
	min_cost_flow_hvq_snas \
	min_cost_flow_hvq_snas_scaling \
	min_cost_flow_hvq_snbaldef \
	min_cost_flow_hvq_snbaldef_def0 \
	min_cost_flow_hvq_snbaldef_sc \
	min_cost_flow_hvq_snbaldef_nsc \
	min_cost_flow_hvq_snbaldef_scaling \
	min_cost_flow_hvq_snbaldef_scaling_def0 \
	min_cost_flow_hvq_snbaldef_scaling_sc \
	min_cost_flow_hvq_snbaldef_scaling_nsc \
	min_cost_flow_hvq_rbn \
	min_cost_flow_hvq_rbn_def0 \
	min_cost_flow_hvq_rbn_sc \
	min_cost_flow_hvq_rbn_nsc \
	min_cost_flow_hvq_rbn_scaling \
	min_cost_flow_hvq_rbn_scaling_def0 \
	min_cost_flow_hvq_rbn_scaling_sc \
	min_cost_flow_hvq_rbn_scaling_nsc \
	min_cost_flow_hvq_rbn_snbal \
	min_cost_flow_hvq_rbn_snbal_def0 \
	min_cost_flow_hvq_rbn_snbal_sc \
	min_cost_flow_hvq_rbn_snbal_nsc \
	min_cost_flow_hvq_rbn_snbal_scaling \
	min_cost_flow_hvq_rbn_snbal_scaling_def0 \
	min_cost_flow_hvq_rbn_snbal_scaling_sc \
	min_cost_flow_hvq_rbn_snbal_scaling_nsc \
	min_cost_flow_hvq_rbn_snbaldef \
	min_cost_flow_hvq_rbn_snbaldef_def0 \
	min_cost_flow_hvq_rbn_snbaldef_sc \
	min_cost_flow_hvq_rbn_snbaldef_nsc \
	min_cost_flow_hvq_rbn_snbaldef_scaling \
	min_cost_flow_hvq_rbn_snbaldef_scaling_def0 \
	min_cost_flow_hvq_rbn_snbaldef_scaling_sc \
	min_cost_flow_hvq_rbn_snbaldef_scaling_nsc

standard_gda_variants: \
	min_cost_flow \
	min_cost_flow_gda \
	min_cost_flow_gda_aq \
	min_cost_flow_gdar \
	min_cost_flow_gdar_aq


min_cost_flow: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS)  min_cost_flow.cpp -o min_cost_flow

min_cost_flow_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_def0

min_cost_flow_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_sc

min_cost_flow_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_nsc

min_cost_flow_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_gda

min_cost_flow_gda_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_gda_def0

min_cost_flow_gda_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_gda_sc

min_cost_flow_gda_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_gda_nsc

min_cost_flow_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_gda_aq

min_cost_flow_gda_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_gda_aq_def0

min_cost_flow_gda_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_gda_aq_sc

min_cost_flow_gda_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_gda_aq_nsc

min_cost_flow_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_gdar

min_cost_flow_gdar_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_gdar_def0

min_cost_flow_gdar_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_gdar_sc

min_cost_flow_gdar_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_gdar_nsc

min_cost_flow_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_gdar_aq

min_cost_flow_gdar_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_gdar_aq_def0

min_cost_flow_gdar_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_gdar_aq_sc

min_cost_flow_gdar_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_gdar_aq_nsc

min_cost_flow_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING min_cost_flow.cpp -o min_cost_flow_scaling

min_cost_flow_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_scaling_def0

min_cost_flow_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_sc

min_cost_flow_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_nsc

min_cost_flow_scaling_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_scaling_gda

min_cost_flow_scaling_gda_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_scaling_gda_def0

min_cost_flow_scaling_gda_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_gda_sc

min_cost_flow_scaling_gda_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_gda_nsc

min_cost_flow_scaling_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_scaling_gda_aq

min_cost_flow_scaling_gda_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_scaling_gda_aq_def0

min_cost_flow_scaling_gda_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_gda_aq_sc

min_cost_flow_scaling_gda_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_gda_aq_nsc

min_cost_flow_scaling_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_scaling_gdar

min_cost_flow_scaling_gdar_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_scaling_gdar_def0

min_cost_flow_scaling_gdar_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_gdar_sc

min_cost_flow_scaling_gdar_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_gdar_nsc

min_cost_flow_scaling_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_scaling_gdar_aq

min_cost_flow_scaling_gdar_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_scaling_gdar_aq_def0

min_cost_flow_scaling_gdar_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_gdar_aq_sc

min_cost_flow_scaling_gdar_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_scaling_gdar_aq_nsc

min_cost_flow_snas: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 min_cost_flow.cpp -o min_cost_flow_snas

min_cost_flow_snas_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_snas_gda

min_cost_flow_snas_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_snas_gda_aq

min_cost_flow_snas_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_snas_gdar

min_cost_flow_snas_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_snas_gdar_aq

min_cost_flow_snas_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DSCALING min_cost_flow.cpp -o min_cost_flow_snas_scaling

min_cost_flow_snas_scaling_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DSCALING -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_snas_scaling_gda

min_cost_flow_snas_scaling_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_snas_scaling_gda_aq

min_cost_flow_snas_scaling_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_snas_scaling_gdar

min_cost_flow_snas_scaling_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=1 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_snas_scaling_gdar_aq

min_cost_flow_snbaldef: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 min_cost_flow.cpp -o min_cost_flow_snbaldef

min_cost_flow_snbaldef_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_def0

min_cost_flow_snbaldef_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_sc

min_cost_flow_snbaldef_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_nsc

min_cost_flow_snbaldef_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_snbaldef_gda

min_cost_flow_snbaldef_gda_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_gda_def0

min_cost_flow_snbaldef_gda_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_gda_sc

min_cost_flow_snbaldef_gda_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_gda_nsc

min_cost_flow_snbaldef_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_snbaldef_gda_aq

min_cost_flow_snbaldef_gda_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_gda_aq_def0

min_cost_flow_snbaldef_gda_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_gda_aq_sc

min_cost_flow_snbaldef_gda_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_gda_aq_nsc

min_cost_flow_snbaldef_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_snbaldef_gdar

min_cost_flow_snbaldef_gdar_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_gdar_def0

min_cost_flow_snbaldef_gdar_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_gdar_sc

min_cost_flow_snbaldef_gdar_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_gdar_nsc

min_cost_flow_snbaldef_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_snbaldef_gdar_aq

min_cost_flow_snbaldef_gdar_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_gdar_aq_def0

min_cost_flow_snbaldef_gdar_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_gdar_aq_sc

min_cost_flow_snbaldef_gdar_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_gdar_aq_nsc

min_cost_flow_snbaldef_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling

min_cost_flow_snbaldef_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_def0

min_cost_flow_snbaldef_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_sc

min_cost_flow_snbaldef_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_nsc

min_cost_flow_snbaldef_scaling_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gda

min_cost_flow_snbaldef_scaling_gda_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gda_def0

min_cost_flow_snbaldef_scaling_gda_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gda_sc

min_cost_flow_snbaldef_scaling_gda_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gda_nsc

min_cost_flow_snbaldef_scaling_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gda_aq

min_cost_flow_snbaldef_scaling_gda_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gda_aq_def0

min_cost_flow_snbaldef_scaling_gda_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gda_aq_sc

min_cost_flow_snbaldef_scaling_gda_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gda_aq_nsc

min_cost_flow_snbaldef_scaling_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gdar

min_cost_flow_snbaldef_scaling_gdar_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gdar_def0

min_cost_flow_snbaldef_scaling_gdar_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gdar_sc

min_cost_flow_snbaldef_scaling_gdar_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gdar_nsc

min_cost_flow_snbaldef_scaling_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gdar_aq

min_cost_flow_snbaldef_scaling_gdar_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gdar_aq_def0

min_cost_flow_snbaldef_scaling_gdar_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gdar_aq_sc

min_cost_flow_snbaldef_scaling_gdar_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_snbaldef_scaling_gdar_aq_nsc

min_cost_flow_rbn: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES min_cost_flow.cpp -o min_cost_flow_rbn

min_cost_flow_rbn_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_def0

min_cost_flow_rbn_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_sc

min_cost_flow_rbn_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_nsc

min_cost_flow_rbn_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_rbn_gda

min_cost_flow_rbn_gda_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_gda_def0

min_cost_flow_rbn_gda_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_gda_sc

min_cost_flow_rbn_gda_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_gda_nsc

min_cost_flow_rbn_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_rbn_gda_aq

min_cost_flow_rbn_gda_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_gda_aq_def0

min_cost_flow_rbn_gda_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_gda_aq_sc

min_cost_flow_rbn_gda_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_gda_aq_nsc

min_cost_flow_rbn_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_rbn_gdar

min_cost_flow_rbn_gdar_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_gdar_def0

min_cost_flow_rbn_gdar_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_gdar_sc

min_cost_flow_rbn_gdar_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_gdar_nsc

min_cost_flow_rbn_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_rbn_gdar_aq

min_cost_flow_rbn_gdar_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_gdar_aq_def0

min_cost_flow_rbn_gdar_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_gdar_aq_sc

min_cost_flow_rbn_gdar_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_gdar_aq_nsc

min_cost_flow_rbn_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING min_cost_flow.cpp -o min_cost_flow_rbn_scaling

min_cost_flow_rbn_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_scaling_def0

min_cost_flow_rbn_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_sc

min_cost_flow_rbn_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_nsc

min_cost_flow_rbn_scaling_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gda

min_cost_flow_rbn_scaling_gda_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gda_def0

min_cost_flow_rbn_scaling_gda_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gda_sc

min_cost_flow_rbn_scaling_gda_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gda_nsc

min_cost_flow_rbn_scaling_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gda_aq

min_cost_flow_rbn_scaling_gda_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gda_aq_def0

min_cost_flow_rbn_scaling_gda_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gda_aq_sc

min_cost_flow_rbn_scaling_gda_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gda_aq_nsc

min_cost_flow_rbn_scaling_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gdar

min_cost_flow_rbn_scaling_gdar_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gdar_def0

min_cost_flow_rbn_scaling_gdar_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gdar_sc

min_cost_flow_rbn_scaling_gdar_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gdar_nsc

min_cost_flow_rbn_scaling_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gdar_aq

min_cost_flow_rbn_scaling_gdar_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gdar_aq_def0

min_cost_flow_rbn_scaling_gdar_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gdar_aq_sc

min_cost_flow_rbn_scaling_gdar_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_scaling_gdar_aq_nsc

min_cost_flow_rbn_snbal: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 min_cost_flow.cpp -o min_cost_flow_rbn_snbal

min_cost_flow_rbn_snbal_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbal_def0

min_cost_flow_rbn_snbal_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbal_sc

min_cost_flow_rbn_snbal_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbal_nsc

min_cost_flow_rbn_snbal_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING min_cost_flow.cpp -o min_cost_flow_rbn_snbal_scaling

min_cost_flow_rbn_snbal_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbal_scaling_def0

min_cost_flow_rbn_snbal_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbal_scaling_sc

min_cost_flow_rbn_snbal_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbal_scaling_nsc

min_cost_flow_rbn_snbaldef: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef

min_cost_flow_rbn_snbaldef_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_def0

min_cost_flow_rbn_snbaldef_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_sc

min_cost_flow_rbn_snbaldef_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_nsc

min_cost_flow_rbn_snbaldef_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gda

min_cost_flow_rbn_snbaldef_gda_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gda_def0

min_cost_flow_rbn_snbaldef_gda_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gda_sc

min_cost_flow_rbn_snbaldef_gda_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gda_nsc

min_cost_flow_rbn_snbaldef_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gda_aq

min_cost_flow_rbn_snbaldef_gda_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gda_aq_def0

min_cost_flow_rbn_snbaldef_gda_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gda_aq_sc

min_cost_flow_rbn_snbaldef_gda_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gda_aq_nsc

min_cost_flow_rbn_snbaldef_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gdar

min_cost_flow_rbn_snbaldef_gdar_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gdar_def0

min_cost_flow_rbn_snbaldef_gdar_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gdar_sc

min_cost_flow_rbn_snbaldef_gdar_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gdar_nsc

min_cost_flow_rbn_snbaldef_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gdar_aq

min_cost_flow_rbn_snbaldef_gdar_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gdar_aq_def0

min_cost_flow_rbn_snbaldef_gdar_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gdar_aq_sc

min_cost_flow_rbn_snbaldef_gdar_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_gdar_aq_nsc

min_cost_flow_rbn_snbaldef_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling

min_cost_flow_rbn_snbaldef_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_def0

min_cost_flow_rbn_snbaldef_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_sc

min_cost_flow_rbn_snbaldef_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_nsc

min_cost_flow_rbn_snbaldef_scaling_gda: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gda

min_cost_flow_rbn_snbaldef_scaling_gda_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gda_def0

min_cost_flow_rbn_snbaldef_scaling_gda_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gda_sc

min_cost_flow_rbn_snbaldef_scaling_gda_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gda_nsc

min_cost_flow_rbn_snbaldef_scaling_gda_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gda_aq

min_cost_flow_rbn_snbaldef_scaling_gda_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gda_aq_def0

min_cost_flow_rbn_snbaldef_scaling_gda_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gda_aq_sc

min_cost_flow_rbn_snbaldef_scaling_gda_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gda_aq_nsc

min_cost_flow_rbn_snbaldef_scaling_gdar: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gdar

min_cost_flow_rbn_snbaldef_scaling_gdar_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gdar_def0

min_cost_flow_rbn_snbaldef_scaling_gdar_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gdar_sc

min_cost_flow_rbn_snbaldef_scaling_gdar_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gdar_nsc

min_cost_flow_rbn_snbaldef_scaling_gdar_aq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gdar_aq

min_cost_flow_rbn_snbaldef_scaling_gdar_aq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gdar_aq_def0

min_cost_flow_rbn_snbaldef_scaling_gdar_aq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gdar_aq_sc

min_cost_flow_rbn_snbaldef_scaling_gdar_aq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DGREEDY_DUAL_ASCENT -DRESIDUAL -DALTERNATION_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_rbn_snbaldef_scaling_gdar_aq_nsc

min_cost_flow_hq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE min_cost_flow.cpp -o min_cost_flow_hq

min_cost_flow_hq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_def0

min_cost_flow_hq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_sc

min_cost_flow_hq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_nsc

min_cost_flow_hq_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSCALING min_cost_flow.cpp -o min_cost_flow_hq_scaling

min_cost_flow_hq_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_scaling_def0

min_cost_flow_hq_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_scaling_sc

min_cost_flow_hq_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_scaling_nsc

min_cost_flow_hq_snas: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=1 min_cost_flow.cpp -o min_cost_flow_hq_snas

min_cost_flow_hq_snas_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=1 -DSCALING min_cost_flow.cpp -o min_cost_flow_hq_snas_scaling

min_cost_flow_hq_snbaldef: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=3 min_cost_flow.cpp -o min_cost_flow_hq_snbaldef

min_cost_flow_hq_snbaldef_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_snbaldef_def0

min_cost_flow_hq_snbaldef_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_snbaldef_sc

min_cost_flow_hq_snbaldef_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_snbaldef_nsc

min_cost_flow_hq_snbaldef_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSCALING min_cost_flow.cpp -o min_cost_flow_hq_snbaldef_scaling

min_cost_flow_hq_snbaldef_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_snbaldef_scaling_def0

min_cost_flow_hq_snbaldef_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_snbaldef_scaling_sc

min_cost_flow_hq_snbaldef_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_snbaldef_scaling_nsc

min_cost_flow_hq_rbn: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES min_cost_flow.cpp -o min_cost_flow_hq_rbn

min_cost_flow_hq_rbn_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_rbn_def0

min_cost_flow_hq_rbn_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_sc

min_cost_flow_hq_rbn_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_nsc

min_cost_flow_hq_rbn_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSCALING min_cost_flow.cpp -o min_cost_flow_hq_rbn_scaling

min_cost_flow_hq_rbn_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_rbn_scaling_def0

min_cost_flow_hq_rbn_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_scaling_sc

min_cost_flow_hq_rbn_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_scaling_nsc

min_cost_flow_hq_rbn_snbal: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbal

min_cost_flow_hq_rbn_snbal_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbal_def0

min_cost_flow_hq_rbn_snbal_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbal_sc

min_cost_flow_hq_rbn_snbal_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbal_nsc

min_cost_flow_hq_rbn_snbal_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbal_scaling

min_cost_flow_hq_rbn_snbal_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbal_scaling_def0

min_cost_flow_hq_rbn_snbal_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbal_scaling_sc

min_cost_flow_hq_rbn_snbal_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbal_scaling_nsc

min_cost_flow_hq_rbn_snbaldef: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbaldef

min_cost_flow_hq_rbn_snbaldef_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbaldef_def0

min_cost_flow_hq_rbn_snbaldef_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbaldef_sc

min_cost_flow_hq_rbn_snbaldef_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbaldef_nsc

min_cost_flow_hq_rbn_snbaldef_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbaldef_scaling

min_cost_flow_hq_rbn_snbaldef_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbaldef_scaling_def0

min_cost_flow_hq_rbn_snbaldef_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbaldef_scaling_sc

min_cost_flow_hq_rbn_snbaldef_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hq_rbn_snbaldef_scaling_nsc

min_cost_flow_hvq: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE min_cost_flow.cpp -o min_cost_flow_hvq

min_cost_flow_hvq_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_def0

min_cost_flow_hvq_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_sc

min_cost_flow_hvq_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_nsc

min_cost_flow_hvq_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSCALING min_cost_flow.cpp -o min_cost_flow_hvq_scaling

min_cost_flow_hvq_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_scaling_def0

min_cost_flow_hvq_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_scaling_sc

min_cost_flow_hvq_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_scaling_nsc

min_cost_flow_hvq_snas: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=1 min_cost_flow.cpp -o min_cost_flow_hvq_snas

min_cost_flow_hvq_snas_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=1 -DSCALING min_cost_flow.cpp -o min_cost_flow_hvq_snas_scaling

min_cost_flow_hvq_snbaldef: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=3 min_cost_flow.cpp -o min_cost_flow_hvq_snbaldef

min_cost_flow_hvq_snbaldef_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_snbaldef_def0

min_cost_flow_hvq_snbaldef_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_snbaldef_sc

min_cost_flow_hvq_snbaldef_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_snbaldef_nsc

min_cost_flow_hvq_snbaldef_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSCALING min_cost_flow.cpp -o min_cost_flow_hvq_snbaldef_scaling

min_cost_flow_hvq_snbaldef_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_snbaldef_scaling_def0

min_cost_flow_hvq_snbaldef_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_snbaldef_scaling_sc

min_cost_flow_hvq_snbaldef_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_snbaldef_scaling_nsc

min_cost_flow_hvq_rbn: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES min_cost_flow.cpp -o min_cost_flow_hvq_rbn

min_cost_flow_hvq_rbn_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_rbn_def0

min_cost_flow_hvq_rbn_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_sc

min_cost_flow_hvq_rbn_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_nsc

min_cost_flow_hvq_rbn_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSCALING min_cost_flow.cpp -o min_cost_flow_hvq_rbn_scaling

min_cost_flow_hvq_rbn_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_rbn_scaling_def0

min_cost_flow_hvq_rbn_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_scaling_sc

min_cost_flow_hvq_rbn_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_scaling_nsc

min_cost_flow_hvq_rbn_snbal: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbal

min_cost_flow_hvq_rbn_snbal_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbal_def0

min_cost_flow_hvq_rbn_snbal_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbal_sc

min_cost_flow_hvq_rbn_snbal_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbal_nsc

min_cost_flow_hvq_rbn_snbal_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbal_scaling

min_cost_flow_hvq_rbn_snbal_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbal_scaling_def0

min_cost_flow_hvq_rbn_snbal_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbal_scaling_sc

min_cost_flow_hvq_rbn_snbal_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=2 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbal_scaling_nsc

min_cost_flow_hvq_rbn_snbaldef: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbaldef

min_cost_flow_hvq_rbn_snbaldef_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbaldef_def0

min_cost_flow_hvq_rbn_snbaldef_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbaldef_sc

min_cost_flow_hvq_rbn_snbaldef_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbaldef_nsc

min_cost_flow_hvq_rbn_snbaldef_scaling: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbaldef_scaling

min_cost_flow_hvq_rbn_snbaldef_scaling_def0: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_IS_ZERO min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbaldef_scaling_def0

min_cost_flow_hvq_rbn_snbaldef_scaling_sc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbaldef_scaling_sc

min_cost_flow_hvq_rbn_snbaldef_scaling_nsc: min_cost_flow.cpp graph.h hybrid_queue.h min_cost_flow_dual_ascent.h min_cost_flow_dual_ascent_default.h min_cost_flow_dual_ascent_queue.h
	$(CC) $(CCFLAGS) -DUSE_HYBRID_VECTOR_QUEUE -DRESTORE_BALANCED_NODES -DSTART_NODE_SELECTION_METHOD=3 -DSCALING -DSTOP_IF_NODE_DEFICIT_SIGN_CHANGES min_cost_flow.cpp -o min_cost_flow_hvq_rbn_snbaldef_scaling_nsc


clean:
	rm -f min_cost_flow \
	      min_cost_flow_def0 \
	      min_cost_flow_sc \
	      min_cost_flow_nsc \
	      min_cost_flow_gda \
	      min_cost_flow_gda_def0 \
	      min_cost_flow_gda_sc \
	      min_cost_flow_gda_nsc \
	      min_cost_flow_gda_aq \
	      min_cost_flow_gda_aq_def0 \
	      min_cost_flow_gda_aq_sc \
	      min_cost_flow_gda_aq_nsc \
	      min_cost_flow_gdar \
	      min_cost_flow_gdar_def0 \
	      min_cost_flow_gdar_sc \
	      min_cost_flow_gdar_nsc \
	      min_cost_flow_gdar_aq \
	      min_cost_flow_gdar_aq_def0 \
	      min_cost_flow_gdar_aq_sc \
	      min_cost_flow_gdar_aq_nsc \
	      min_cost_flow_scaling \
	      min_cost_flow_scaling_def0 \
	      min_cost_flow_scaling_sc \
	      min_cost_flow_scaling_nsc \
	      min_cost_flow_scaling_gda \
	      min_cost_flow_scaling_gda_def0 \
	      min_cost_flow_scaling_gda_sc \
	      min_cost_flow_scaling_gda_nsc \
	      min_cost_flow_scaling_gda_aq \
	      min_cost_flow_scaling_gda_aq_def0 \
	      min_cost_flow_scaling_gda_aq_sc \
	      min_cost_flow_scaling_gda_aq_nsc \
	      min_cost_flow_scaling_gdar \
	      min_cost_flow_scaling_gdar_def0 \
	      min_cost_flow_scaling_gdar_sc \
	      min_cost_flow_scaling_gdar_nsc \
	      min_cost_flow_scaling_gdar_aq \
	      min_cost_flow_scaling_gdar_aq_def0 \
	      min_cost_flow_scaling_gdar_aq_sc \
	      min_cost_flow_scaling_gdar_aq_nsc \
	      min_cost_flow_snas \
	      min_cost_flow_snas_gda \
	      min_cost_flow_snas_gda_aq \
	      min_cost_flow_snas_gdar \
	      min_cost_flow_snas_gdar_aq \
	      min_cost_flow_snas_scaling \
	      min_cost_flow_snas_scaling_gda \
	      min_cost_flow_snas_scaling_gda_aq \
	      min_cost_flow_snas_scaling_gdar \
	      min_cost_flow_snas_scaling_gdar_aq \
	      min_cost_flow_snbaldef \
	      min_cost_flow_snbaldef_def0 \
	      min_cost_flow_snbaldef_sc \
	      min_cost_flow_snbaldef_nsc \
	      min_cost_flow_snbaldef_gda \
	      min_cost_flow_snbaldef_gda_def0 \
	      min_cost_flow_snbaldef_gda_sc \
	      min_cost_flow_snbaldef_gda_nsc \
	      min_cost_flow_snbaldef_gda_aq \
	      min_cost_flow_snbaldef_gda_aq_def0 \
	      min_cost_flow_snbaldef_gda_aq_sc \
	      min_cost_flow_snbaldef_gda_aq_nsc \
	      min_cost_flow_snbaldef_gdar \
	      min_cost_flow_snbaldef_gdar_def0 \
	      min_cost_flow_snbaldef_gdar_sc \
	      min_cost_flow_snbaldef_gdar_nsc \
	      min_cost_flow_snbaldef_gdar_aq \
	      min_cost_flow_snbaldef_gdar_aq_def0 \
	      min_cost_flow_snbaldef_gdar_aq_sc \
	      min_cost_flow_snbaldef_gdar_aq_nsc \
	      min_cost_flow_snbaldef_scaling \
	      min_cost_flow_snbaldef_scaling_def0 \
	      min_cost_flow_snbaldef_scaling_sc \
	      min_cost_flow_snbaldef_scaling_nsc \
	      min_cost_flow_snbaldef_scaling_gda \
	      min_cost_flow_snbaldef_scaling_gda_def0 \
	      min_cost_flow_snbaldef_scaling_gda_sc \
	      min_cost_flow_snbaldef_scaling_gda_nsc \
	      min_cost_flow_snbaldef_scaling_gda_aq \
	      min_cost_flow_snbaldef_scaling_gda_aq_def0 \
	      min_cost_flow_snbaldef_scaling_gda_aq_sc \
	      min_cost_flow_snbaldef_scaling_gda_aq_nsc \
	      min_cost_flow_snbaldef_scaling_gdar \
	      min_cost_flow_snbaldef_scaling_gdar_def0 \
	      min_cost_flow_snbaldef_scaling_gdar_sc \
	      min_cost_flow_snbaldef_scaling_gdar_nsc \
	      min_cost_flow_snbaldef_scaling_gdar_aq \
	      min_cost_flow_snbaldef_scaling_gdar_aq_def0 \
	      min_cost_flow_snbaldef_scaling_gdar_aq_sc \
	      min_cost_flow_snbaldef_scaling_gdar_aq_nsc \
	      min_cost_flow_rbn \
	      min_cost_flow_rbn_def0 \
	      min_cost_flow_rbn_sc \
	      min_cost_flow_rbn_nsc \
	      min_cost_flow_rbn_gda \
	      min_cost_flow_rbn_gda_def0 \
	      min_cost_flow_rbn_gda_sc \
	      min_cost_flow_rbn_gda_nsc \
	      min_cost_flow_rbn_gda_aq \
	      min_cost_flow_rbn_gda_aq_def0 \
	      min_cost_flow_rbn_gda_aq_sc \
	      min_cost_flow_rbn_gda_aq_nsc \
	      min_cost_flow_rbn_gdar \
	      min_cost_flow_rbn_gdar_def0 \
	      min_cost_flow_rbn_gdar_sc \
	      min_cost_flow_rbn_gdar_nsc \
	      min_cost_flow_rbn_gdar_aq \
	      min_cost_flow_rbn_gdar_aq_def0 \
	      min_cost_flow_rbn_gdar_aq_sc \
	      min_cost_flow_rbn_gdar_aq_nsc \
	      min_cost_flow_rbn_scaling \
	      min_cost_flow_rbn_scaling_def0 \
	      min_cost_flow_rbn_scaling_sc \
	      min_cost_flow_rbn_scaling_nsc \
	      min_cost_flow_rbn_scaling_gda \
	      min_cost_flow_rbn_scaling_gda_def0 \
	      min_cost_flow_rbn_scaling_gda_sc \
	      min_cost_flow_rbn_scaling_gda_nsc \
	      min_cost_flow_rbn_scaling_gda_aq \
	      min_cost_flow_rbn_scaling_gda_aq_def0 \
	      min_cost_flow_rbn_scaling_gda_aq_sc \
	      min_cost_flow_rbn_scaling_gda_aq_nsc \
	      min_cost_flow_rbn_scaling_gdar \
	      min_cost_flow_rbn_scaling_gdar_def0 \
	      min_cost_flow_rbn_scaling_gdar_sc \
	      min_cost_flow_rbn_scaling_gdar_nsc \
	      min_cost_flow_rbn_scaling_gdar_aq \
	      min_cost_flow_rbn_scaling_gdar_aq_def0 \
	      min_cost_flow_rbn_scaling_gdar_aq_sc \
	      min_cost_flow_rbn_scaling_gdar_aq_nsc \
	      min_cost_flow_rbn_snbal \
	      min_cost_flow_rbn_snbal_def0 \
	      min_cost_flow_rbn_snbal_sc \
	      min_cost_flow_rbn_snbal_nsc \
	      min_cost_flow_rbn_snbal_scaling \
	      min_cost_flow_rbn_snbal_scaling_def0 \
	      min_cost_flow_rbn_snbal_scaling_sc \
	      min_cost_flow_rbn_snbal_scaling_nsc \
	      min_cost_flow_rbn_snbaldef \
	      min_cost_flow_rbn_snbaldef_def0 \
	      min_cost_flow_rbn_snbaldef_sc \
	      min_cost_flow_rbn_snbaldef_nsc \
	      min_cost_flow_rbn_snbaldef_gda \
	      min_cost_flow_rbn_snbaldef_gda_def0 \
	      min_cost_flow_rbn_snbaldef_gda_sc \
	      min_cost_flow_rbn_snbaldef_gda_nsc \
	      min_cost_flow_rbn_snbaldef_gda_aq \
	      min_cost_flow_rbn_snbaldef_gda_aq_def0 \
	      min_cost_flow_rbn_snbaldef_gda_aq_sc \
	      min_cost_flow_rbn_snbaldef_gda_aq_nsc \
	      min_cost_flow_rbn_snbaldef_gdar \
	      min_cost_flow_rbn_snbaldef_gdar_def0 \
	      min_cost_flow_rbn_snbaldef_gdar_sc \
	      min_cost_flow_rbn_snbaldef_gdar_nsc \
	      min_cost_flow_rbn_snbaldef_gdar_aq \
	      min_cost_flow_rbn_snbaldef_gdar_aq_def0 \
	      min_cost_flow_rbn_snbaldef_gdar_aq_sc \
	      min_cost_flow_rbn_snbaldef_gdar_aq_nsc \
	      min_cost_flow_rbn_snbaldef_scaling \
	      min_cost_flow_rbn_snbaldef_scaling_def0 \
	      min_cost_flow_rbn_snbaldef_scaling_sc \
	      min_cost_flow_rbn_snbaldef_scaling_nsc \
	      min_cost_flow_rbn_snbaldef_scaling_gda \
	      min_cost_flow_rbn_snbaldef_scaling_gda_def0 \
	      min_cost_flow_rbn_snbaldef_scaling_gda_sc \
	      min_cost_flow_rbn_snbaldef_scaling_gda_nsc \
	      min_cost_flow_rbn_snbaldef_scaling_gda_aq \
	      min_cost_flow_rbn_snbaldef_scaling_gda_aq_def0 \
	      min_cost_flow_rbn_snbaldef_scaling_gda_aq_sc \
	      min_cost_flow_rbn_snbaldef_scaling_gda_aq_nsc \
	      min_cost_flow_rbn_snbaldef_scaling_gdar \
	      min_cost_flow_rbn_snbaldef_scaling_gdar_def0 \
	      min_cost_flow_rbn_snbaldef_scaling_gdar_sc \
	      min_cost_flow_rbn_snbaldef_scaling_gdar_nsc \
	      min_cost_flow_rbn_snbaldef_scaling_gdar_aq \
	      min_cost_flow_rbn_snbaldef_scaling_gdar_aq_def0 \
	      min_cost_flow_rbn_snbaldef_scaling_gdar_aq_sc \
	      min_cost_flow_rbn_snbaldef_scaling_gdar_aq_nsc \
	      min_cost_flow_hq \
	      min_cost_flow_hq_def0 \
	      min_cost_flow_hq_sc \
	      min_cost_flow_hq_nsc \
	      min_cost_flow_hq_scaling \
	      min_cost_flow_hq_scaling_def0 \
	      min_cost_flow_hq_scaling_sc \
	      min_cost_flow_hq_scaling_nsc \
	      min_cost_flow_hq_snas \
	      min_cost_flow_hq_snas_scaling \
	      min_cost_flow_hq_snbaldef \
	      min_cost_flow_hq_snbaldef_def0 \
	      min_cost_flow_hq_snbaldef_sc \
	      min_cost_flow_hq_snbaldef_nsc \
	      min_cost_flow_hq_snbaldef_scaling \
	      min_cost_flow_hq_snbaldef_scaling_def0 \
	      min_cost_flow_hq_snbaldef_scaling_sc \
	      min_cost_flow_hq_snbaldef_scaling_nsc \
	      min_cost_flow_hq_rbn \
	      min_cost_flow_hq_rbn_def0 \
	      min_cost_flow_hq_rbn_sc \
	      min_cost_flow_hq_rbn_nsc \
	      min_cost_flow_hq_rbn_scaling \
	      min_cost_flow_hq_rbn_scaling_def0 \
	      min_cost_flow_hq_rbn_scaling_sc \
	      min_cost_flow_hq_rbn_scaling_nsc \
	      min_cost_flow_hq_rbn_snbal \
	      min_cost_flow_hq_rbn_snbal_def0 \
	      min_cost_flow_hq_rbn_snbal_sc \
	      min_cost_flow_hq_rbn_snbal_nsc \
	      min_cost_flow_hq_rbn_snbal_scaling \
	      min_cost_flow_hq_rbn_snbal_scaling_def0 \
	      min_cost_flow_hq_rbn_snbal_scaling_sc \
	      min_cost_flow_hq_rbn_snbal_scaling_nsc \
	      min_cost_flow_hq_rbn_snbaldef \
	      min_cost_flow_hq_rbn_snbaldef_def0 \
	      min_cost_flow_hq_rbn_snbaldef_sc \
	      min_cost_flow_hq_rbn_snbaldef_nsc \
	      min_cost_flow_hq_rbn_snbaldef_scaling \
	      min_cost_flow_hq_rbn_snbaldef_scaling_def0 \
	      min_cost_flow_hq_rbn_snbaldef_scaling_sc \
	      min_cost_flow_hq_rbn_snbaldef_scaling_nsc \
	      min_cost_flow_hvq \
	      min_cost_flow_hvq_def0 \
	      min_cost_flow_hvq_sc \
	      min_cost_flow_hvq_nsc \
	      min_cost_flow_hvq_scaling \
	      min_cost_flow_hvq_scaling_def0 \
	      min_cost_flow_hvq_scaling_sc \
	      min_cost_flow_hvq_scaling_nsc \
	      min_cost_flow_hvq_snas \
	      min_cost_flow_hvq_snas_scaling \
	      min_cost_flow_hvq_snbaldef \
	      min_cost_flow_hvq_snbaldef_def0 \
	      min_cost_flow_hvq_snbaldef_sc \
	      min_cost_flow_hvq_snbaldef_nsc \
	      min_cost_flow_hvq_snbaldef_scaling \
	      min_cost_flow_hvq_snbaldef_scaling_def0 \
	      min_cost_flow_hvq_snbaldef_scaling_sc \
	      min_cost_flow_hvq_snbaldef_scaling_nsc \
	      min_cost_flow_hvq_rbn \
	      min_cost_flow_hvq_rbn_def0 \
	      min_cost_flow_hvq_rbn_sc \
	      min_cost_flow_hvq_rbn_nsc \
	      min_cost_flow_hvq_rbn_scaling \
	      min_cost_flow_hvq_rbn_scaling_def0 \
	      min_cost_flow_hvq_rbn_scaling_sc \
	      min_cost_flow_hvq_rbn_scaling_nsc \
	      min_cost_flow_hvq_rbn_snbal \
	      min_cost_flow_hvq_rbn_snbal_def0 \
	      min_cost_flow_hvq_rbn_snbal_sc \
	      min_cost_flow_hvq_rbn_snbal_nsc \
	      min_cost_flow_hvq_rbn_snbal_scaling \
	      min_cost_flow_hvq_rbn_snbal_scaling_def0 \
	      min_cost_flow_hvq_rbn_snbal_scaling_sc \
	      min_cost_flow_hvq_rbn_snbal_scaling_nsc \
	      min_cost_flow_hvq_rbn_snbaldef \
	      min_cost_flow_hvq_rbn_snbaldef_def0 \
	      min_cost_flow_hvq_rbn_snbaldef_sc \
	      min_cost_flow_hvq_rbn_snbaldef_nsc \
	      min_cost_flow_hvq_rbn_snbaldef_scaling \
	      min_cost_flow_hvq_rbn_snbaldef_scaling_def0 \
	      min_cost_flow_hvq_rbn_snbaldef_scaling_sc \
	      min_cost_flow_hvq_rbn_snbaldef_scaling_nsc
