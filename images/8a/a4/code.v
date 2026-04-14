module top_module(
        input [1:0] x,
        input h,
        output reg X);

	always_comb begin
		case ({x, h})
			3'b000: X = 1'b1;
			3'b001: X = 1'b0;
			3'b010: X = 1'b1;
			3'b011: X = 1'b0;
			3'b100: X = 1'b0;
			3'b101: X = 1'b1;
			3'b110: X = 1'b1;
			3'b111: X = 1'b0;
			default: X = 1'bx;
		endcase
	end
	
endmodule