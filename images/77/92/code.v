module top_module( In_1,In_0,Out,select );input [15:0] In_0,In_1;
	input select;
	wire [15:0] In_0,In_1;
	wire select;
	output [15:0] Out;
	wire [15:0] Out;	
	assign Out = (select == 1)?(In_1):(In_0);endmodule