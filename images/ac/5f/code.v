module top_module(
        input [2:1] y,
        input w,
        output reg Z0);always_comb begin
		case ({y, w})
			3'b000: Z0 = 1'b0;
			3'b001: Z0 = 1'b1;
			3'b010: Z0 = 1'b1;
			3'b011: Z0 = 1'b0;
			3'b100: Z0 = 1'b0;
			3'b101: Z0 = 1'b1;
			default: Z0 = 1'bx;
		endcase
	end
	
endmodule