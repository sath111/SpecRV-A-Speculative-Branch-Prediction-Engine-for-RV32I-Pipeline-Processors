## Simulation & Testing  
To verify the behavior and robustness of the Gshare branch predictor, three distinct test programs were used, each designed to stress different aspects of branch prediction, data independence, and control flow.  
These test cases were written in RV32I assembly and converted to machine code for simulation. The primary goal was to monitor prediction accuracy, detect mispredictions, and evaluate the effectiveness of the snapshot and rollback mechanism under various scenarios.  
## How to Run the Simulation
The simulation setup uses Icarus Verilog to compile and execute the hardware design, and GTKWave to inspect the resulting waveform. A dedicated testbench is used to drive the CPU with different test cases provided in machine code format.  
1. Prepare the test case
   Each test program is written in RV32I assembly and compiled into a .hex or .txt file, which is loaded into instruction memory by the testbench.  
2. Compile the design and testbench
   ```
   iverilog -o RV32I_top_tb RV32I_top_tb.v
   ```
3. Run the simulation
   ```
   vvp RV32I_top_tb
   ```
4. View the waveform
   ```
   gtkwave RV32I_top_tb.vcd
   ```
This setup allows for full-cycle debugging and insight into the internal behavior of the Gshare predictor, including how it responds to control flow, how speculation is handled, and how rollback is triggered on mispredictions.  

### Test 1 – Independent Arithmetic Instructions
This test includes a sequence of independent arithmetic instructions that do not involve branching. It serves as a control case, allowing us to verify that the predictor does not interfere when branches are not present, and that speculative execution proceeds as expected.  
```
addi x1, x0, 5
addi x2, x0, 7
add  x3, x1, x2     # x3 = 5 + 7 = 12
sub  x4, x2, x1     # x4 = 7 - 5 = 2
or   x5, x1, x2     # x5 = 5 | 7 = 7
```
**Purpose**: ensures that the pipeline operates correctly in the absence of branches and that the predictor remains idle without introducing noise or false speculation.  
**Waveform Observation** 
![Waveform Test 1](../Image/waveform_test1.png)


### Test 2 – Memory Access with Control Flow
This test mixes arithmetic and memory access with a small data forwarding scenario. The memory operations help verify that speculative instructions following stores and loads are not incorrectly flushed. It also allows indirect observation of pipeline correctness around control signals.
```
addi x2, x0, 5        # x2 = 5
addi x6, x0, 8        # x6 = 8
add  x7, x3, x6       # x7 = x3 + x6
addi x1, x0, 0        # x1 = 0
addi x3, x0, 10       # x3 = 10 (address)
sw   x2, 0(x3)        # MEM[10] = 5
lw   x4, 0(x3)        # x4 = 5
add  x5, x4, x2       # x5 = 5 + 5 = 10
```
**Purpose**: validates that instructions not dependent on branches are still correctly executed even with memory interaction. It checks for proper behavior of pipeline flush logic when no branches are involved.  
**Waveform Observation** 
![Waveform Test 2](../Image/waveform_test2.png)

**Test 3 – Nested Loops with Branches (Gshare-focused)**  
This test is specifically designed to evaluate the Gshare branch predictor’s performance. It consists of a nested loop using beq and jal, challenging the predictor with multiple control-flow patterns, especially backward branches which form tight loops.  
```
addi x0, x0, 0          # nop
addi x1, x0, 0          # x1 = 0 (outer loop counter)
addi x2, x0, 10         # x2 = 10 (outer loop limit)
addi x4, x0, 4          # x4 = 4 (inner loop limit)

CONTINUE:
beq x1, x2, SKIP1       # branch: outer loop exit condition
addi x1, x1, 1
addi x3, x0, 0          # x3 = 0 (inner loop counter)

LOOP:
beq x3, x4, CONTINUE    # branch: inner loop exit
addi x3, x3, 1
jal x0, LOOP            # unconditional jump to LOOP

SKIP1:
add x5, x1, x2          # final addition
jal x0, SKIP1           # infinite loop (halt simulation)
```

Purpose:
This is the main stress test for Gshare. The predictor must learn:  
* That beq x3, x4 and beq x1, x2 have different histories and frequency  
* That jal is always taken  
* To quickly recover from mispredictions using snapshots  
By monitoring GHSR behavior and observing misprediction recovery in the waveform, this test highlights how well the predictor adapts to nested control flow and whether the rollback mechanism works correctly.  

