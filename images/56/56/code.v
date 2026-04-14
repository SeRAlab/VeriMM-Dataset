module top_module( 
	input [3:0] Data1, 
	input [3:0] Data2, 
	output lt, gt, eq ) ;assign lt = (Data1 < Data2) ; 
	assign gt = (Data1 > Data2) ; 
	assign eq = (Data1 == Data2) ;endmodule