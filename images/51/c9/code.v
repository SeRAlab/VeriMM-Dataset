module top_module(din, dout);(* LOC = "P2" *)
	input wire din;

	(* LOC = "P20 P19 P18 P17 P16 P15 P13 P12 P10 P9 P8 P7 P6 P5 P4 P3" *)
	output wire[15:0] dout;

	
	

	
	assign dout = {16{din}};

endmodule