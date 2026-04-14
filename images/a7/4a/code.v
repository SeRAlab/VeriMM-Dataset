module top_module(
    input [3:0] Num,
    output [7:0] Out
    );assign Out = 	Num == 0 ? 8'b10000001:
						Num == 1 ? 8'b11001111:
						Num == 2 ? 8'b10010010:
						Num == 3 ? 8'b10000110:
						Num == 4 ? 8'b11001100:
						Num == 5 ? 8'b10100100:
						Num == 6 ? 8'b10100000:
						Num == 7 ? 8'b10001111:
						Num == 8 ? 8'b10000000:
						Num == 9 ? 8'b10000100:
						Num == 10 ? 8'b10001000:
						Num == 11 ? 8'b11100000:
						Num == 12 ? 8'b10110001:
						Num == 13 ? 8'b11000010:
						Num == 14 ? 8'b10110000:
						8'b10111000;

endmodule