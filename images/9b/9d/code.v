module top_module(
	input [3:0] num,
	output [6:0] display
	);assign display = 
		num == 0 ? ~7'b0111111:
		num == 1 ? ~7'b0000110:
		num == 2 ? ~7'b1011011:
		num == 3 ? ~7'b1001111:
		num == 4 ? ~7'b1100110:
		num == 5 ? ~7'b1101101:
		num == 6 ? ~7'b1111101:
		num == 7 ? ~7'b0000111:
		num == 8 ? ~7'b1111111:
		num == 9 ? ~7'b1100111:
		7'bxxxxxxx;
endmodule