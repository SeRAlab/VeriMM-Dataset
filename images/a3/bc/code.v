module top_module (
	input [8:0] i,
	output [3:0] upper_nibble,
	output [3:0] lower_nibble);assign upper_nibble = i[8:5];
	assign lower_nibble = i[3:0];
	
endmodule