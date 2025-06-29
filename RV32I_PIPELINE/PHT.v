module PHT #(
    parameter d_width = 8
)
(
    input clk, rst_n,
    input i_update,
    input i_actual_taken,
    input [d_width -1 : 0] i_addr_update,

    input [d_width -1 : 0] i_addr,
    output reg o_predict
);

reg [1:0] pht_mem [0 : ((1 << d_width) -1)];

localparam Strong_NT = 2'b00,
           Weak_NT = 2'b01,
           Weak_T = 2'b10,
           Strong_T = 2'b11;

integer i;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        for(i = 0; i < (1 << d_width); i = i + 1) begin
            pht_mem[i] <= Weak_NT;
        end
    end
    else begin
        if(i_update) begin
            case(pht_mem[i_addr_update]) 
                Strong_NT: pht_mem[i_addr_update] <= (i_actual_taken) ? Weak_NT : Strong_NT;
                Weak_NT: pht_mem[i_addr_update] <= (i_actual_taken) ? Weak_T : Strong_NT;
                Weak_T: pht_mem[i_addr_update] <= (i_actual_taken) ? Strong_T: Weak_NT;
                Strong_T: pht_mem[i_addr_update] <= (i_actual_taken) ? Strong_T : Weak_T;
            endcase
        end
    end
end

//predict
always @(*) begin
    case(pht_mem[i_addr]) 
        Strong_NT: o_predict = 0;
        Weak_NT : o_predict = 0;
        Weak_T: o_predict = 1;
        Strong_T: o_predict = 1;
    endcase
end


endmodule