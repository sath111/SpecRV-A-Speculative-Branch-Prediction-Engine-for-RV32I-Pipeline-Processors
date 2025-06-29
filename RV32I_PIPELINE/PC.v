module PC #(
    parameter d_width = 32
)
(
    input clk, rst_n,
    input en, flush,

    input [1:0] PC_src,
    input [31:0] PC_target_btb,
    input i_predict,
    input [7:0] i_addr_PHT,
    output reg [1:0] F_PC_src,
    output reg [31:0] F_PC_target_btb,
    output reg F_predict,
    output reg [7:0] F_addr_PHT,

    
    input [d_width -1 : 0] i_PC_next,
    output reg [d_width -1 : 0] F_PC_cur
);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        F_PC_src <= 2'd0;
        F_PC_target_btb <= 32'd0;
        F_predict <= 1'd0;
        F_addr_PHT <= 8'd0;
        F_PC_cur <= 32'd0;
    end
    else begin
        if(flush) begin
            F_PC_src <= 2'd0;
            F_PC_target_btb <= 32'd0;
            F_predict <= 1'd0;
            F_addr_PHT <= 8'd0;
            F_PC_cur <= 32'd0;
        end
        else if(en) begin
            F_PC_src <= PC_src;
            F_PC_target_btb <= PC_target_btb;
            F_predict <= i_predict;
            F_addr_PHT <= i_addr_PHT;
            F_PC_cur <= i_PC_next;
        end
    end
end

endmodule