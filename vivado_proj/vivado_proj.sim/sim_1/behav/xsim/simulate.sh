#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Sat Feb 08 11:47:36 +03 2025
# SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim rv32i_soc_tb_behav -key {Behavioral:sim_1:Functional:rv32i_soc_tb} -tclbatch rv32i_soc_tb.tcl -log simulate.log"
xsim rv32i_soc_tb_behav -key {Behavioral:sim_1:Functional:rv32i_soc_tb} -tclbatch rv32i_soc_tb.tcl -log simulate.log

