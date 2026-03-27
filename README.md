# Simplified Memory Controller with DRAM-like Timing (SystemVerilog)

## Overview
This project implements a simplified memory controller in SystemVerilog to model key DRAM behaviors, including read/write latency, burst access, and periodic refresh cycles. The design demonstrates how memory access is scheduled and how timing constraints impact system behavior.

## Features
- FSM-based controller (IDLE / READ / WRITE / REFRESH)
- Configurable read and write latency parameters
- Burst transfer support for sequential memory access
- Refresh mechanism that temporarily blocks memory operations
- Functional verification through simulation and waveform analysis

## Key Concepts
- Memory access scheduling and arbitration
- Latency vs. throughput trade-offs
- DRAM-like timing behavior (simplified abstraction)

## Tools
- SystemVerilog
- Icarus Verilog
- GTKWave

## Example Behavior
- Burst write stores sequential data across consecutive addresses
- Burst read retrieves data with defined latency before output
- Periodic refresh cycles temporarily block memory access

## Example Waveform

### Full System Behavior
![Full Waveform](waveform_full.png)

Overall controller behavior including write, refresh, and read phases.

### Read Burst and Latency (Zoom-In)
![Zoomed Waveform](waveform_zoom.png)

Demonstrates read latency and burst transfer (64 → 67), along with state transitions.
