module IF_ID(
    input clk, rst_n,
    input en, flush,

    input [1:0] F_PC_src,
    input [31:0] F_PC_target_btb,
    input F_predict,
    input [7:0] F_addr_PHT,
    input [31:0] F_ins,
    input [31:0] F_PC_cur,
    input [31:0] F_PC_next,

    output reg [1:0] D_PC_src,
    output reg [31:0] D_PC_targer_btb,
    output reg D_predict,
    output reg [7:0] D_addr_PHT,
    output reg [31:0] D_ins,
    output reg [31:0] D_PC_cur,
    output reg [31:0] D_PC_next
);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        D_PC_src <= 2'd0;
        D_PC_targer_btb <= 32'd0;
        D_predict <= 1'd0;
        D_addr_PHT <= 8'd0;
        D_ins <= 32'd0;
        D_PC_cur <= 32'd0;
        D_PC_next <= 32'd0;
    end
    else begin
        if(flush) begin
            D_PC_src <= 2'd0;
            D_PC_targer_btb <= 32'd0;
            D_predict <= 1'd0;
            D_addr_PHT <= 8'd0;
            D_ins <= 32'd0;
            D_PC_cur <= 32'd0;
            D_PC_next <= 32'd0;
        end
        else if(en) begin
            D_PC_src <= F_PC_src;
            D_PC_targer_btb <= F_PC_target_btb;
            D_predict <= F_predict;
            D_addr_PHT <= F_addr_PHT;
            D_ins <= F_ins;
            D_PC_cur <= F_PC_cur;
            D_PC_next <= F_PC_next;
        end
    end
end

endmodule