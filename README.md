# SpecRV:A Speculative Branch Prediction Engine for RV32I Pipeline Processors
This project implements a lightweight and modular speculative branch prediction engine based on the Gshare algorithm, designed for RV32I 5-stage in-order pipeline processors.

# Overview / Introduction
Branch prediction is a critical performance feature in pipelined processors, helping to reduce control hazards by speculatively executing instructions before the outcome of a branch is resolved. This project introduces a Verilog-based Gshare branch predictor, implemented alongside a simple RV32I 5-stage pipeline CPU.
The system includes modular components such as a Global History Shift Register (GHSR), a Pattern History Table (PHT), a Branch Target Buffer (BTB), and a snapshot-based rollback mechanism for misprediction handling.

# Goals and Key Features
* Implement a Gshare branch predictor that combines global branch history with PC indexing.
* Predict conditional and unconditional branch outcomes in the Instruction Fetch stage.
* Recover from mispredictions using a snapshot and rollback mechanism.
* Enable modular, parameterized design that can be easily extended or reused.
* 
