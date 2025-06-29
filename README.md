# SpecRV: A Speculative Branch Prediction Engine for RV32I Pipeline Processors
* This project introduces SpecRV, a lightweight yet powerful speculative branch prediction engine tailored specifically for RV32I 5-stage in-order pipelined processors. Built around the well-known Gshare algorithm, SpecRV aims to enhance pipeline efficiency by minimizing control hazards introduced by branch instructions—both conditional and unconditional.  

# Overview / Introduction
* Branch prediction is a critical performance feature in pipelined processors, helping to reduce control hazards by speculatively executing instructions before the outcome of a branch is resolved. This project introduces a Verilog-based Gshare branch predictor, implemented alongside a simple RV32I 5-stage pipeline CPU.  
* The system includes modular components such as a Global History Shift Register (GHSR), a Pattern History Table (PHT), a Branch Target Buffer (BTB), and a snapshot-based rollback mechanism for misprediction handling.  

# Goals and Key Features
* Implement a Gshare branch predictor that combines global branch history with PC indexing.
* Predict conditional and unconditional branch outcomes in the Instruction Fetch stage.
* Recover from mispredictions using a snapshot and rollback mechanism.
* Enable modular, parameterized design that can be easily extended or reused.

# Architecture Overview
* The overall architecture of this system includes a Gshare predictor integrated into a standard 5-stage RV32I pipeline. The predictor influences the instruction fetch path by speculatively supplying the next PC and is later corrected if the prediction was wrong.  
* The system captures the relationship between BTB, GHSR, PHT, and the pipeline stages responsible for resolving branches. Mispredictions trigger a flush and rollback mechanism using a stored snapshot of the predictor state.  
To help visualize the design, a complete architecture diagram is provided:  
View the full system diagram here: [Insert your draw.io or shared image link]  

# Modules Breakdown
**Global History Shift Register (GHSR)**  
The GHSR maintains a history of recent branch outcomes, represented as a shift register. Each time a branch is executed, its actual taken/not-taken result is shifted into the register. This history allows the system to detect patterns and use them for future predictions. The length of the GHSR is configurable (e.g., 6–12 bits), impacting the size and resolution of the Pattern History Table.  

**Pattern History Table (PHT)**  
The PHT is an array of 2-bit saturating counters used to predict the outcome of a branch. The table is indexed by XORing the current PC with the GHSR, which helps spread out correlated branches across the table and reduce aliasing. Each counter indicates how likely a given history pattern is to result in a taken or not-taken decision. Updates are made after the actual branch outcome is known.  

**Branch Target Buffer (BTB)**  
The BTB is a small associative memory that stores target addresses for recently executed branch or jump instructions. Each BTB entry contains a tag (from the PC), a valid bit, and the predicted target PC. If a matching entry is found during the fetch stage, the pipeline speculates to the given target address. The BTB is crucial for jump-type instructions such as jal, jalr, and for conditional branches.  

**Control Unit**  
This unit combines information from the BTB, GHSR, and PHT to make a final prediction. It determines whether a branch is predicted taken and calculates the next PC accordingly. The unit also handles branch classification to distinguish between different branch types and applies specific prediction rules based on instruction behavior.  

**Snapshot & Mispredict Handler**  
To handle mispredictions, the system takes a snapshot of the predictor state (including GHSR and PC) at the time of branch fetch. If the prediction is later discovered to be incorrect, this snapshot is used to restore the correct state and flush any incorrectly speculated instructions from the pipeline. This mechanism improves accuracy and is essential for implementing advanced predictors such as tournament-based models.  
 
# Simulation & Testing
To verify the behavior and effectiveness of the Gshare branch prediction engine, this project includes a set of focused test programs located in the Simulation&Testing/ directory. These test cases are written in RV32I assembly and compiled to machine code, targeting specific aspects of branch prediction such as:  
* Control flow without branches (baseline test)  
* Mixed arithmetic and memory operations  
* Nested loops with both conditional (beq) and unconditional (jal) branches  

The tests are designed to validate:    
* Prediction accuracy across repeated control-flow patterns  
* Snapshot and rollback correctness on mispredictions  
* Compatibility of the predictor with memory operations and instruction forwarding   
Xem toàn bộ chi tiết và phân tích tại: Simulation&Testing/  

# Performance Gains from Early Branch Prediction
* Conditional branches such as beq and bne benefit significantly from the integration of the Gshare predictor. By maintaining a global history register (GHSR) and consulting a pattern history table (PHT) using XOR indexing, the predictor can anticipate whether a branch is likely to be taken or not. This prediction happens at the fetch stage, allowing the pipeline to preemptively decide the control flow before the instruction is decoded or executed. When the prediction is accurate, the pipeline avoids control stalls; if mispredicted, a snapshot-based recovery mechanism restores the correct path with minimal penalty.

* Unconditional jumps, such as jal and jalr, are always treated as taken and rely solely on the BTB to provide the jump target. When a valid BTB entry is found, the pipeline can fetch from the target address immediately during the IF stage without waiting to compute the jump offset. This early resolution is especially valuable in loops and function calls, where repeated jumps are common. The result is a clear reduction in latency and improved instruction throughput.

* Together, the BTB and Gshare predictor form a complementary system that minimizes control hazards while maintaining correctness. Their collaboration enables the pipeline to remain continuously fed with useful instructions, and ensures that mispredictions are corrected quickly and cleanly. This architecture provides strong performance even in complex branching scenarios, laying a solid foundation for future expansion into more advanced processors.

# Conclusion
* This project presents a speculative branch prediction engine designed specifically for RV32I pipeline processors, combining a Gshare predictor with a Branch Target Buffer (BTB) and snapshot-based recovery. Through careful integration at the fetch stage, the system can accurately anticipate control flow for both conditional and unconditional branches, significantly reducing stalls and improving instruction throughput. The predictor has been validated through simulation with realistic test cases, including nested loops and memory interactions, demonstrating its correctness and performance advantages. This design not only enhances execution flow in traditional in-order pipelines, but also lays the groundwork for future extensions in out-of-order architectures. SpecRV serves as both a functional module and an educational platform to explore speculative execution, control flow prediction, and microarchitectural optimization in RISC-V systems.



