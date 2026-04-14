module top_module(din, dout);(* LOC = "P2" *)
	input wire din;

	(* LOC = "P14 P13 P12 P11 P10 P9 P7 P6 P5 P4 P3" *)
	output wire[10:0] dout;

	
	

	
	assign dout = {11{din}};

endmodule