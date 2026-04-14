module top_module(Columns, Rows, KeyNumber);input [3:0] Columns;
	input [3:0] Rows;
	output reg [4:0] KeyNumber;

	parameter NoKey = 0;
	parameter key1 = 1;
	parameter key2 = 2;
	parameter key3 = 3;
	parameter key4 = 4;
	parameter key5 = 5;
	parameter key6 = 6;
	parameter key7 = 7;
	parameter key8 = 8;
	parameter key9 = 9;
	parameter keyA = 10;
	parameter keyB = 11;
	parameter keyC = 12;
	parameter keyD = 13;
	parameter keyStar = 14;
	parameter key0 = 15;
	parameter keyPound = 16;
	
	always@(Columns or Rows)
	case ({ Columns, Rows })
		8'b01110111: KeyNumber <= key1;
		8'b10110111: KeyNumber <= key2;
		8'b11010111: KeyNumber <= key3;
		8'b01111011: KeyNumber <= key4;
		8'b10111011: KeyNumber <= key5;
		8'b11011011: KeyNumber <= key6;
		8'b01111101: KeyNumber <= key7;
		8'b10111101: KeyNumber <= key8;
		8'b11011101: KeyNumber <= key9;
		8'b11100111: KeyNumber <= keyA;
		8'b11101011: KeyNumber <= keyB;
		8'b11101101: KeyNumber <= keyC;
		8'b11101110: KeyNumber <= keyD;
		8'b01111110: KeyNumber <= keyStar;
		8'b10111110: KeyNumber <= key0;
		8'b11011110: KeyNumber <= keyPound;
		default: KeyNumber <= NoKey;
	endcase
endmodule