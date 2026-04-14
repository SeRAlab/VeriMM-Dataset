module top_module (
	input [4:0] j,
	output [3:0] out_and,
	output [4:0] out_xor);assign out_and = j[3:0] & j[4:1];
	assign out_xor = j ^ {j[0], j[4:1]};
	
endmodule