module ADD #(
    parameter d_width = 32
)
(
    input signed  [d_width -1 : 0] i_data0,
    input signed  [d_width -1 : 0] i_data1,
    output signed  [d_width -1 : 0] o_data
);

assign o_data = i_data0 + i_data1;

endmodule