module top_module(
	input wire c5,
	input wire c6,
	input wire c7,
	input wire c8,
	input wire c12,
	input wire c13,
	input wire c14,
	input wire c15,
	input wire c16,
	output wire intr,
	output wire sync);wire line, field;
	
	assign line = ~(c5 | c7) & c6 & c8;
	assign field = c12 & c13 & c14 & c15 & c16;
	assign sync = ~(line | field);
	assign intr = ~field;
endmodule