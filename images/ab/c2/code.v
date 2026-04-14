module top_module( 
	output [3:0] out , 
	input sel, 
	input [3:0] Data1, 
	input [3:0] Data2 ) ;assign out = sel ? Data2 : Data1 ;endmodule