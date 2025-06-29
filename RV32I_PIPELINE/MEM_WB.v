module MEM_WB(
    input clk, rst_n,

    input [1:0] M_wb,
    input M_wen_rf,
    input [31:0] M_ALUresult,
    input [31:0] M_DMEMresult,
    input [31:0] M_PC_next,
    input [4:0] M_rd,

    output reg [1:0] W_wb,
    output reg W_wen_rf,
    output reg [31:0] W_ALUresult,
    output reg [31:0] W_DMEMresult,
    output reg [31:0] W_PC_next,
    output reg [4:0] W_rd
);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        W_wb <= 2'd0;
        W_wen_rf <= 1'd0;
        W_ALUresult <= 32'd0;
        W_DMEMresult <= 32'd0;
        W_PC_next <= 32'd0;
        W_rd <= 5'd0;
    end
    else begin
        W_wb <= M_wb;
        W_wen_rf <= M_wen_rf;
        W_ALUresult <= M_ALUresult;
        W_DMEMresult <= M_DMEMresult;
        W_PC_next <= M_PC_next;
        W_rd <= M_rd;
    end
end

endmodule