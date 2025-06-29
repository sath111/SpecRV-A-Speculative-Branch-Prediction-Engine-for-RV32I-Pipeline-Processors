module EX_MEM(
    input clk, rst_n,
    
    input [1:0] E_wb,
    input [2:0] E_funct3,
    input E_load_store,
    input E_endmem,
    input E_wen_rf,
    input [31:0] E_ALUresult,
    input [31:0] E_wdata,
    input [31:0] E_PC_next,
    input [4:0] E_rd,

    output reg [1:0] M_wb,
    output reg [2:0] M_funct3,
    output reg M_load_store,
    output reg M_endmem,
    output reg M_wen_rf,
    output reg [31:0] M_ALUresult,
    output reg [31:0] M_wdata,
    output reg [31:0] M_PC_next,
    output reg [4:0] M_rd
);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        M_wb <= 2'd0;
        M_funct3 <= 3'd0;
        M_load_store <= 1'd0;
        M_endmem <= 1'd0;
        M_wen_rf <= 1'd0;
        M_ALUresult <= 32'd0;
        M_wdata <= 32'd0;
        M_PC_next <= 32'd0;
        M_rd <= 5'd0;
    end
    else begin 
        M_wb <= E_wb;
        M_funct3 <= E_funct3;
        M_load_store <= E_load_store;
        M_endmem <= E_endmem;
        M_wen_rf <= E_wen_rf;
        M_ALUresult <= E_ALUresult;
        M_wdata <= E_wdata;
        M_PC_next <= E_PC_next;
        M_rd <= E_rd;
    end
end

endmodule