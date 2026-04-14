module top_module(
	 input [31:0] In1,
	 input [31:0] In2,
	 input Op,
	 output [31:0] Out
	 );assign Out=(Op==0)? In1 :In2;endmodule