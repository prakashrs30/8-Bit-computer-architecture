# 8-Bit SAP-1 Computer Architecture on FPGA

[![FPGA](https://img.shields.io/badge/FPGA-Xilinx%20Spartan--7-blue.svg)](https://www.xilinx.com)
[![Board](https://img.shields.io/badge/Board-RealDigital%20Boolean-green.svg)](https://www.realdigital.org/hardware/boolean)
[![Toolchain](https://img.shields.io/badge/Vivado-2020.1-orange.svg)](https://www.xilinx.com/products/design-tools/vivado.html)
[![Language](https://img.shields.io/badge/HDL-Verilog--2001-red.svg)]()

A complete hardware implementation of an **8-bit SAP-1 (Simple As Possible) computer** designed in Verilog HDL and implemented on the **RealDigital Boolean Board** (AMD/Xilinx Spartan-7 `XC7S50CSGA324-1`). 

The design features a central 8-bit bus architecture, an onboard 100 MHz-to-1 Hz clock divider for human-observable execution, interactive runtime RAM programming via **Vivado VIO (Virtual Input/Output)**, dual output via physical binary LEDs, and real-time decimal decoding on the onboard **4-digit 7-segment display**.

---

## 📌 Key Features

* **Classical SAP-1 Datapath:**
  * 4-bit Program Counter (PC)
  * Memory Address Register (MAR)
  * 16 × 8-bit Synchronous RAM
  * 8-bit Instruction Register (IR)
  * 8-bit Accumulator (Register A) & 8-bit Register B
  * 8-bit ALU with Carry & Zero flag detection
  * 8-bit Output Register
  * Microcoded / FSM Control Unit with 6 T-states per instruction
* **Interactive In-System RAM Programming:**
  * Integrated **Xilinx VIO (Virtual Input/Output)** core over JTAG.
  * Allows loading instructions and data into FPGA RAM at runtime without re-synthesizing or regenerating bitstreams.
* **Human-Observable Clocking:**
  * 100 MHz oscillator divided down to **1 Hz** for real-time visual tracking of step-by-step micro-operations.
  * Parameterized speedup available for sub-microsecond behavioral simulation in Vivado `xsim`.
* **Dual Physical Display:**
  * **Binary Output:** 8 green LEDs (`LD0` – `LD7`) show the raw 8-bit output.
  * **Decimal Output:** Built-in Binary-to-BCD converter and 380 Hz time-multiplexed 7-segment display controller (`D0`) show human-readable decimal results (e.g. `0055`).
  * **Status Indicator:** Dedicated Halted LED (`LD15`).

---

## 🏗️ System Architecture

```text
                     +---------------------------------------+
                     |           CENTRAL 8-BIT BUS           |
                     +---+-------+-------+-------+-------+---+
                         |       |       |       |       |
                 +-------+   +---+---+   |   +---+---+   |
                 |  PC   |   |  MAR  |   |   | REG A |   |
                 +-------+   +---+---+   |   +---+---+   |
                                 |       |       |       |
                             +---+---+   |   +---+---+   |
                             |  RAM  |   |   |  ALU  |   |
                             | 16x8  |   |   +---+---+   |
                             +-------+   |       |       |
                                         |   +---+---+   |
                                 +-------+   | REG B |   |
                                 |  IR   |   +-------+   |
                                 +---+---+               |
                                     |               +---+---+
                                 +---+---+           | OUT   |
                                 | CTRL  |           +---+---+
                                 | UNIT  |               |
                                 +---+---+       +-------+-------+
                                     |           |               |
                               Control Signals  LEDs (LD0..7)   7-Segment (D0)
                                                 [Binary]         [Decimal]
