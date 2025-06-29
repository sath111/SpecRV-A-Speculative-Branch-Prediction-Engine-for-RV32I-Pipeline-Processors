module GHSR #(
    parameter d_width = 8
)
(
    input clk, rst_n,
    input i_ac, 
    input i_update,
    output reg [d_width -1 : 0] o_ghsr
);

always @(posedge clk, negedge rst_n) begin
    if(~rst_n) begin
        o_ghsr <= {d_width{1'b0}};
    end
    else begin
        if(i_update) begin
            o_ghsr <= {o_ghsr[d_width -2 :0], i_ac};
        end
    end
end

endmodule