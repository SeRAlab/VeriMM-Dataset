module top_module(
    input [3:0] A,
    output reg [7:0] SevenSegValue
    );always @(*)
		begin
			case(A)
				4'h0: SevenSegValue <= ~8'b11111100;
				4'h1: SevenSegValue <= ~8'b01100000;
				4'h2: SevenSegValue <= ~8'b11011010;
				4'h3: SevenSegValue <= ~8'b11110010;
				4'h4: SevenSegValue <= ~8'b01100110;
				4'h5: SevenSegValue <= ~8'b10110110;
				4'h6: SevenSegValue <= ~8'b10111110;
				4'h7: SevenSegValue <= ~8'b11100000;
				4'h8: SevenSegValue <= ~8'b11111110;
				4'h9: SevenSegValue <= ~8'b11110110;
				4'hA: SevenSegValue <= ~8'b11101110;
				4'hB: SevenSegValue <= ~8'b00111110;
				4'hC: SevenSegValue <= ~8'b10011100;
				4'hD: SevenSegValue <= ~8'b01111010;
				4'hE: SevenSegValue <= ~8'b10011110;
				default: SevenSegValue <= ~8'b10001110;				
			endcase
		end
endmodule