module top_module( In_7,In_6,In_5,In_4,In_3,In_2,In_1,In_0,Out,select );input [15:0] In_0,In_1,In_2,In_3,In_4,In_5,In_6,In_7;
	input [2:0] select;
	wire [15:0] In_0,In_1,In_2,In_3,In_4,In_5,In_6,In_7;
	wire [2:0] select;
	output [15:0] Out;
	wire [15:0] Out;
	assign Out = ((!select[2])&(!select[1])&(!select[0]))?(In_0):(((!select[2])&(!select[1])&(select[0]))?(In_1):(((!select[2])&(select[1])&(!select[0]))?(In_2):(((!select[2])&(select[1])&(select[0]))?(In_3):(((select[2])&(!select[1])&(!select[0]))?(In_4):(((select[2])&(!select[1])&(select[0]))?(In_5):(((select[2])&(select[1])&(!select[0]))?(In_6):(((select[2])&(select[1])&(select[0]))?(In_7):(16'bzzzzzzzzzzzzzzzz))))))));endmodule