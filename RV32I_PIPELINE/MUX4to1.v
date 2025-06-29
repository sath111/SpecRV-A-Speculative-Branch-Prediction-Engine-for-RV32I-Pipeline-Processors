module MUX4to1 #(
    parameter d_width = 32
)
(
    input [d_width -1 : 0] i_data0,
    input [d_width -1 : 0] i_data1,
    input [d_width -1 : 0] i_data2,
    input [d_width -1 : 0] i_data3,
    input [1:0] i_select,
    output reg [d_width -1 : 0] o_data
);

always @(*) begin
    case(i_select)
        2'd0: o_data = i_data0;
        2'd1: o_data = i_data1;
        2'd2: o_data = i_data2;
        2'd3: o_data = i_data3;
    endcase
end

endmodule