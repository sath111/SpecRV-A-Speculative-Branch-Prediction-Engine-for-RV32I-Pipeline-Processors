module IMEM #(
    parameter a_width = 32,
    parameter d_width = 32
)
(
    input [a_width - 1 : 0] i_addr,
    output reg [d_width - 1 : 0] o_ins
);

reg [32:0] mem [0:32]; // 256 instruction

initial begin
    $readmemh("E:/RV32I_PIPELINE/code.txt", mem);
end

always @(*) begin
    o_ins = mem[i_addr >> 2];
end

endmodule