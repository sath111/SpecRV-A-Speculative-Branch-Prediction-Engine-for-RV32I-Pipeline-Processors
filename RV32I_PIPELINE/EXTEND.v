module EXTEND(
	input [2:0] i_Imm,
	input [24:0] i_data,
	output reg [31:0] o_data
);

	always @(*) begin
		case(i_Imm) 
			3'b000: o_data = {{20{i_data[24]}}, i_data[24:13]}; //I
			3'b001: o_data = {{20{i_data[24]}}, i_data[24:18], i_data[4:0]}; //S
			3'b010: o_data = {{20{i_data[24]}}, i_data[0], i_data[23:18], i_data[4:1], 1'b0}; //B
			3'b011: o_data = {{27{1'b0}}, i_data[17:13]}; //shift
			3'b100: o_data = {{12{i_data[24]}}, i_data[12:5], i_data[13], i_data[23:14], 1'b0}; //j
			3'b101: o_data = {{13{i_data[24]}}, i_data[24:5]}; //lui
			default: o_data = 32'd0;
		endcase 
	end
endmodule