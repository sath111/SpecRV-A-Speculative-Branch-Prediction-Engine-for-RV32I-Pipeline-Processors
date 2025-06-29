module BTB #(
    parameter d_width = 32
)
(
    input clk, rst_n,
    input [d_width -1 : 0] i_E_PC_cur,
    input [d_width -1 : 0] i_E_PC_branch,
    input i_update_btb,
    input i_jump,

    input [d_width -1 : 0] i_F_PC,
    output [d_width -1 : 0] o_PC_target,
    output o_jump,
    output o_hit_btb
);

//tag = i_F_PC[31:9]
//index = i_F_PC[8:2]
//offset = i_F_PC[1:0] = 00
wire [22:0] tag_F;
wire [6:0] index_F;
assign tag_F = i_F_PC[31:9];
assign index_F = i_F_PC[8:2];

wire [22:0] tag_E;
wire [6:0] index_E;
assign tag_E = i_E_PC_cur[31:9];
assign index_E = i_E_PC_cur[8:2];

reg [22:0] tag_PC [0:127];
reg [31:0] mem_PC_targer [0:127];
reg valid [0:127];
reg jump [0:127];

integer i;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        for(i = 0; i < 128; i = i + 1) begin
            tag_PC[i] <= 23'd0;
            mem_PC_targer[i] <= 32'd0;
            valid[i] <= 1'd0;
            jump[i] <= 1'd0;
        end
    end
    else begin
        if(i_update_btb) begin
            tag_PC[index_E] <= tag_E;
            mem_PC_targer[index_E] <= i_E_PC_branch;
            valid[index_E] <= 1'd1;
            jump[index_E] <= i_jump;
        end
    end
end

assign o_hit_btb = (tag_F == tag_PC[index_F]) & valid[index_F];
assign o_PC_target = (o_hit_btb) ? mem_PC_targer[index_F] : 32'd0;
assign o_jump = jump[index_F];

endmodule