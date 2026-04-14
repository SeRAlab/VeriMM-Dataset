module top_module(
	input A, 
	input B,
	input cin, 
	output S
);assign S = A^B^cin;endmodule