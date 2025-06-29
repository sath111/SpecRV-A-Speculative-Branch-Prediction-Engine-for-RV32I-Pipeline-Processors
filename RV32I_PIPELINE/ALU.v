module ALU #(
    parameter d_width = 32,
    parameter op = 4
)
(
    input [op -1 : 0] i_opcode,
    input [d_width -1 : 0] i_data1,
    input [d_width -1 : 0] i_data2,
    output reg [d_width -1 : 0] o_result,
    output reg o_zero
);

always @(*) begin
    case(i_opcode)
        4'b0000: o_result = i_data1 + i_data2; //add
        4'b0001: o_result = i_data1 - i_data2; //sub
        4'b0010: o_result = i_data1 << i_data2; // sll
        4'b0011: begin //slt
            if(i_data1[31] != i_data2[31]) begin
                if(i_data1[31]) begin
                    o_result = 32'd1;
                end
                else begin
                    o_result = 32'd0;
                end
            end
            else begin
                o_result = (i_data1 < i_data2) ? 1 : 0;
            end
        end
        4'b0100: o_result = (i_data1 < i_data2) ? 1 : 0; //sltu
        4'b0101: o_result = i_data1 ^ i_data2; //xor
        4'b0110: o_result = i_data1 >> i_data2; // srl
        4'b0111: o_result = i_data1 >>> i_data2; //sra
        4'b1000: o_result = i_data1 | i_data2; //or
        4'b1001: o_result = i_data1 & i_data2; //and
        default: o_result = 32'd0;
    endcase
    o_zero = (o_result == 32'd0) ? 1 : 0;
end 

endmodule