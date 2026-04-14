module top_module(
	input a,
	input b, 
	input carry_i,
	output sum,
	output carry_o);assign sum = a ^ b ^ carry_i;
	assign carry_o = (a & b) | (a & carry_i) | (b & carry_i);


endmodule