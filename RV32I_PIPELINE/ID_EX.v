module ID_EX(
    input clk, rst_n,
    input flush,

    input D_predict,
    input [7:0] D_addr_PHT,
    input D_jump,
    input D_branch,
    input [1:0] D_wb,
    input [2:0] D_funct3,
    input D_load_store,
    input D_endmem,
    input [3:0] D_alucontrol,
    input D_alu_src,
    input D_wen_rf,

    input [31:0] D_rdata1,
    input [31:0] D_rdata2,
    input [31:0] D_extend,
    input [31:0] D_PC_cur,
    input [31:0] D_PC_next,

    input [4:0] D_rd,
    input [4:0] D_rs1,
    input [4:0] D_rs2,
    
    output reg E_predict,
    output reg [7:0] E_addr_PHT,
    output reg E_jump,
    output reg E_branch,
    output reg [1:0] E_wb,
    output reg [2:0] E_funct3,
    output reg E_load_store,
    output reg E_endmem,
    output reg [3:0] E_alucontrol,
    output reg E_alu_src,
    output reg E_wen_rf,

    output reg [31:0] E_rdata1,
    output reg [31:0] E_rdata2,
    output reg [31:0] E_extend,
    output reg [31:0] E_PC_cur,
    output reg [31:0] E_PC_next,

    output reg [4:0] E_rd,
    output reg [4:0] E_rs1,
    output reg [4:0] E_rs2
);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        E_predict <= 1'd0;
        E_addr_PHT <= 8'd0;
        E_jump <= 1'd0;
        E_branch <= 1'b0;
        E_wb <= 2'd0;
        E_funct3 <= 3'd0;
        E_load_store <= 1'd0;
        E_endmem <= 1'd0;
        E_alucontrol <= 4'd0;
        E_alu_src <= 1'd0;
        E_wen_rf <= 1'd0;

        E_rdata1 <= 32'd0;
        E_rdata2 <= 32'd0;
        E_extend <= 32'd0;
        E_PC_cur <= 32'd0;
        E_PC_next <= 32'd0;

        E_rd <= 5'd0;
        E_rs1 <= 5'd0;
        E_rs2 <= 5'd0;
    end
    else begin
        if(flush) begin
            E_predict <= 1'd0;
            E_addr_PHT <= 8'd0;
            E_jump <= 1'd0;
            E_branch <= 1'b0;
            E_wb <= 2'd0;
            E_funct3 <= 3'd0;
            E_load_store <= 1'd0;
            E_endmem <= 1'd0;
            E_alucontrol <= 4'd0;
            E_alu_src <= 1'd0;
            E_wen_rf <= 1'd0;

            E_rdata1 <= 32'd0;
            E_rdata2 <= 32'd0;
            E_extend <= 32'd0;
            E_PC_cur <= 32'd0;
            E_PC_next <= 32'd0;

            E_rd <= 5'd0;
            E_rs1 <= 5'd0;
            E_rs2 <= 5'd0;
        end
        else begin
            E_predict <= D_predict;
            E_addr_PHT <= D_addr_PHT;
            E_jump <= D_jump;
            E_branch <= D_branch;
            E_wb <= D_wb;
            E_funct3 <= D_funct3;
            E_load_store <= D_load_store;
            E_endmem <= D_endmem;
            E_alucontrol <= D_alucontrol;
            E_alu_src <= D_alu_src;
            E_wen_rf <= D_wen_rf;

            E_rdata1 <= D_rdata1;
            E_rdata2 <= D_rdata2;
            E_extend <= D_extend;
            E_PC_cur <= D_PC_cur;
            E_PC_next <= D_PC_next;

            E_rd <= D_rd;
            E_rs1 <= D_rs1;
            E_rs2 <= D_rs2;
        end
    end
end

endmodule