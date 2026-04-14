module two_bit_output(clk, b, so);
input clk;
input [3:0] b;
output [1:0] so;
reg [1:0] so;

	always @(posedge clk)
		case (b)
			4'b0000, 4'b0001, 4'b0010: so = 2'b00;
			4'b0011, 4'b0100: so = 2'b01;
			4'b0101, 4'b0110: so = 2'b10;
			4'b0111: so = 2'b11;
			default: so = 2'b00;
		endcase

endmodule