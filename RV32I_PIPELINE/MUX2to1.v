module MUX2to1 #(
    parameter d_width = 32
)
(
    input [d_width -1 : 0] i_data1,
    input [d_width -1 : 0] i_data2,
    input i_select,
    output [d_width -1 : 0] o_data
);

assign o_data = (i_select) ? i_data2 : i_data1;

endmodule