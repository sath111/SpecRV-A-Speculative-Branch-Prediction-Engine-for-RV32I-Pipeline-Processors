# SpecRV: A Speculative Branch Prediction Engine for RV32I Pipeline Processors
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

# Modules Breakdown
Global History Shift Register (GHSR)  
  The GHSR maintains a history of recent branch outcomes, represented as a shift register. Each time a branch is executed, its actual taken/not-taken result is shifted into the register. This history allows the system to detect patterns and use them for future predictions. The length of the GHSR is configurable (e.g., 6–12 bits), impacting the size and resolution of the Pattern History Table.  

Pattern History Table (PHT)  
The PHT is an array of 2-bit saturating counters used to predict the outcome of a branch. The table is indexed by XORing the current PC with the GHSR, which helps spread out correlated branches across the table and reduce aliasing. Each counter indicates how likely a given history pattern is to result in a taken or not-taken decision. Updates are made after the actual branch outcome is known.  

Branch Target Buffer (BTB)  
The BTB is a small associative memory that stores target addresses for recently executed branch or jump instructions. Each BTB entry contains a tag (from the PC), a valid bit, and the predicted target PC. If a matching entry is found during the fetch stage, the pipeline speculates to the given target address. The BTB is crucial for jump-type instructions such as jal, jalr, and for conditional branches.  

Control Unit  
This unit combines information from the BTB, GHSR, and PHT to make a final prediction. It determines whether a branch is predicted taken and calculates the next PC accordingly. The unit also handles branch classification to distinguish between different branch types and applies specific prediction rules based on instruction behavior.  

Snapshot & Mispredict Handler  
To handle mispredictions, the system takes a snapshot of the predictor state (including GHSR and PC) at the time of branch fetch. If the prediction is later discovered to be incorrect, this snapshot is used to restore the correct state and flush any incorrectly speculated instructions from the pipeline. This mechanism improves accuracy and is essential for implementing advanced predictors such as tournament-based models.  
