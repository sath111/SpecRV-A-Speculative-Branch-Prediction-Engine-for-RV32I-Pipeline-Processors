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

# Architecture Overview
The overall architecture of this system includes a Gshare predictor integrated into a standard 5-stage RV32I pipeline. The predictor influences the instruction fetch path by speculatively supplying the next PC and is later corrected if the prediction was wrong.  
The system captures the relationship between BTB, GHSR, PHT, and the pipeline stages responsible for resolving branches. Mispredictions trigger a flush and rollback mechanism using a stored snapshot of the predictor state.  
To help visualize the design, a complete architecture diagram is provided:  
View the full system diagram here: [Insert your draw.io or shared image link]  
