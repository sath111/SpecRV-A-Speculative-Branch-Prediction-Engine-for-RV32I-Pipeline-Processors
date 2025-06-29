`include "RV32I_top.v"

module RV32I_top_tb;

reg clk, rst_n;
reg [31:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;

RV32I_top dut(
    .clk(clk),
    .rst_n(rst_n)
);

always #5 clk = ~clk;

integer i;
always @(negedge clk) begin
    r0 = dut.REGISTERFILE_inst.mem[0];
    r1 = dut.REGISTERFILE_inst.mem[1];
    r2 = dut.REGISTERFILE_inst.mem[2];
    r3 = dut.REGISTERFILE_inst.mem[3];
    r4 = dut.REGISTERFILE_inst.mem[4];
    r5 = dut.REGISTERFILE_inst.mem[5];
    r6 = dut.REGISTERFILE_inst.mem[6];
    r7 = dut.REGISTERFILE_inst.mem[7];
    r8 = dut.REGISTERFILE_inst.mem[8];
    r9 = dut.REGISTERFILE_inst.mem[9];
end

initial begin
    
    $dumpfile("RV32I_top_tb.vcd");
    $dumpvars(0, RV32I_top_tb);
//    $dumpvars(0, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9);

    clk = 0;
    rst_n = 0;

    #30 rst_n = 1;

    #10000;

    $finish;

end


endmodule
