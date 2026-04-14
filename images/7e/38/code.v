module top_module(Data, Seg);input [3:0] Data;
output reg [7:0] Seg;
always @(*)
	begin
		case (Data)
				4'b0000: Seg[7:0] <= 8'b00000011; // 0
				4'b0001: Seg[7:0] <= 8'b10011111; // 1
				4'b0010: Seg[7:0] <= 8'b00100101; // 2
				4'b0011: Seg[7:0] <= 8'b00001101; // 3
				4'b0100: Seg[7:0] <= 8'b10011001; // 4
				4'b0101: Seg[7:0] <= 8'b01001001; // 5
				4'b0110: Seg[7:0] <= 8'b01000001; // 6
				4'b0111: Seg[7:0] <= 8'b00011111; // 7
				4'b1000: Seg[7:0] <= 8'b00000001; // 8
				4'b1001: Seg[7:0] <= 8'b00001001; // 9
				default: Seg[7:0] <= 8'b11111111; // invalid input
		endcase
	end
endmodule