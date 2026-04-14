module top_module(
        input [1:0] y,
        input b,
        output reg V);
	
	always_comb begin
		case ({y, b})
			3'b000: V = 1'b0;
			3'b001: V = 1'b1;
			3'b010: V = 1'b1;
			3'b011: V = 1'b0;
			3'b100: V = 1'b1;
			3'b101: V = 1'b0;
			3'b110: V = 1'b1;
			3'b111: V = 1'b0;
			default: V = 1'bx;
		endcase
	end
	
endmodule