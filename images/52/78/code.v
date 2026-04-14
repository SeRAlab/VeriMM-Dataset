module top_module(
	 input [31:0] In1,
	 input [31:0] In2,
	 input [31:0] In3,
	 input [31:0] In4,
	 input [1:0] Op,
	 output [31:0] Out
	 );assign Out=(Op==0)? In1 :
					(Op==1)? In2 :
					(Op==2)? In3 : In4;endmodule