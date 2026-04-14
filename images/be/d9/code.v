module arith_right_shifter (
	input [7:0] data_in,
	output [7:0] data_out);

	assign data_out = {data_in[7], data_in[7:1]};
	
endmodule