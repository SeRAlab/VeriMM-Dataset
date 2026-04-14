module top_module(Columns, Rows, Clock, Reset, OnesDigit, TensDigit, Found);input [3:0] Columns;
	input [3:0] Rows;
	input Clock, Reset;
	output reg [3:0] OnesDigit;
	output reg [3:0] TensDigit;
	output reg Found;
	parameter NoKey = 9'd0;
	parameter key1 = 9'b100000001;
	parameter key2 = 9'b100000010;
	parameter key3 = 9'b100000011;
	parameter key4 = 9'b100000100;
	parameter key5 = 9'b100000101;
	parameter key6 = 9'b100000110;
	parameter key7 = 9'b100000111;
	parameter key8 = 9'b100001000;
	parameter key9 = 9'b100001001;
	parameter keyA = 9'b100010000;
	parameter keyB = 9'b100010001;
	parameter keyC = 9'b100010010;
	parameter keyD = 9'b100010011;
	parameter keyStar = 9'b100010100;
	parameter key0 = 9'b100010101;
	parameter keyPound = 9'b100010110;
	always@(posedge Clock or posedge Reset)
	if (Reset == 1) {Found, TensDigit, OnesDigit} <= NoKey;
	else case ({ Columns, Rows })
		8'b01110111: {Found, TensDigit, OnesDigit} <= key1;
		8'b10110111: {Found, TensDigit, OnesDigit} <= key2;
		8'b11010111: {Found, TensDigit, OnesDigit} <= key3;
		8'b01111011: {Found, TensDigit, OnesDigit} <= key4;
		8'b10111011: {Found, TensDigit, OnesDigit} <= key5;
		8'b11011011: {Found, TensDigit, OnesDigit} <= key6;
		8'b01111101: {Found, TensDigit, OnesDigit} <= key7;
		8'b10111101: {Found, TensDigit, OnesDigit} <= key8;
		8'b11011101: {Found, TensDigit, OnesDigit} <= key9;
		8'b11100111: {Found, TensDigit, OnesDigit} <= keyA;
		8'b11101011: {Found, TensDigit, OnesDigit} <= keyB;
		8'b11101101: {Found, TensDigit, OnesDigit} <= keyC;
		8'b11101110: {Found, TensDigit, OnesDigit} <= keyD;
		8'b01111110: {Found, TensDigit, OnesDigit} <= keyStar;
		8'b10111110: {Found, TensDigit, OnesDigit} <= key0;
		8'b11011110: {Found, TensDigit, OnesDigit} <= keyPound;
		default: {Found, TensDigit, OnesDigit} <= NoKey;
	endcase
endmodule