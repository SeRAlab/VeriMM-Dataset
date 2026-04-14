module and_not_logic(
	input wire a,
	input wire b,
	output wire y);assign y = ~a & b;

endmodule