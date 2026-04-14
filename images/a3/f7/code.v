module top_module(din_a, din_b, din_c, dout);////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// I/O declarations

	(* LOC = "P20 P2 P7 P14" *)
	input wire[3:0] din_a;

	(* LOC = "P3 P19 P6 P15" *)
	input wire[3:0] din_b;

	(* LOC = "P13 P8 P10 P16" *)
	input wire[3:0] din_c;

	(* LOC = "P9 P4 P5 P12" *)
	output wire[3:0] dout;

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// The adder

	wire[3:0] sum;
	assign sum = din_a + din_b + din_c;
	assign dout = sum;

endmodule