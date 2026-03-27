# Simplified Memory Controller with DRAM-like Timing (SystemVerilog)

## Overview
This project implements a simplified memory controller in SystemVerilog to model key DRAM behaviors, including read/write latency, burst access, and periodic refresh cycles.

## Features
- FSM-based controller (IDLE / READ / WRITE / REFRESH)
- Configurable read/write latency
- Burst transfer support
- Refresh mechanism that blocks memory access
- Simulation and waveform verification

## Key Concepts
- Memory access scheduling
- Latency vs throughput trade-offs
- DRAM-like timing behavior (simplified)

## Tools
- SystemVerilog
- Icarus Verilog
- GTKWave

## Example Behavior
- Burst write stores sequential data
- Burst read retrieves data with latency delay
- Refresh temporarily blocks memory operations
