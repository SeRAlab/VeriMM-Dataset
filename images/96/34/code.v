module top_module(
	input wire A, 
	input wire B, 
	input wire Cin, 
	output wire P, 
	output wire G, 
	output wire S 
);assign P = A | B;
	assign G = A & B; 
	assign S = A ^ B ^ Cin;endmodule