module top_module( In_2,In_1,In_0,Out,select );input [2:0] In_0,In_1,In_2;
	input [1:0] select;
	wire [2:0] In_0,In_1,In_2;
	wire [1:0] select;
	output [2:0] Out;
	wire [2:0] Out;
	assign Out = ((!select[1])&(!select[0]))?(In_0):(((!select[1])&(select[0]))?(In_1):(((select[1])&(!select[0]))?(In_2):(16'bzzzzzzzzzzzzzzzz)));endmodule