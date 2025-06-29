module REGISTERFILE #(
    parameter a_width = 5,
    parameter d_width = 32
)
(
    input clk, rst_n,
    input [a_width -1 : 0] i_raddr1,
    input [a_width -1 : 0] i_raddr2,
    input [a_width -1 : 0] i_waddr,
    input [d_width -1 : 0] i_wdata,
    input i_wen_rf,
    
    output [d_width -1 : 0] o_rdata1,
    output [d_width -1 : 0] o_rdata2
);

reg [31:0] mem [0:31];
integer i;

always @(negedge clk, negedge rst_n) begin
    if(~rst_n) begin
        for(i = 0; i < 32; i = i + 1) begin
            mem[i] <= 32'd0;
        end
    end
    else begin
        if(i_wen_rf && i_waddr != 5'd0) begin
            mem[i_waddr] <= i_wdata;
        end
    end
end

assign o_rdata1 = mem[i_raddr1];
assign o_rdata2 = mem[i_raddr2];

endmodule