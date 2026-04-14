module top_module(
	input A,
	input B,
	input sel,
	output res
	);assign res = B&sel | A&(~sel);
endmodule