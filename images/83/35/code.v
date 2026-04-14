module top_module(input clk, input [31:0]line0, input [31:0]line1, input [31:0]line2, input [31:0]line3, output [31:0]outline0, output [31:0]outline1, output [31:0]outline2, output [31:0]outline3, input ready, input decrypt);wire [23:0]msb;
	wire [23:0]lsb;

	
	function [31:0]eShiftRow;
		input [1:0]rownum;
		input [23:0]msb;
		input [23:0]lsb;
		eShiftRow = (lsb << (rownum * 8))+msb;
	endfunction

	function [31:0]dShiftRow;
		input [1:0]rownum;
		input [23:0]msb;
		input [23:0]lsb;
		input [1:0]shift;
		dShiftRow = (msb >> (rownum * 8))+ (lsb << (shift*8));
	endfunction




			assign outline0[31:0] = line0[31:0]; 
			assign outline1[31:0] = eShiftRow(1, line1[31:24], line1[23:0]);
			assign outline2[31:0] = eShiftRow(2, line2[31:16], line2[15:0]);
			assign outline3[31:0] = eShiftRow(3, line3[31:8], line3[7:0]);









endmodule