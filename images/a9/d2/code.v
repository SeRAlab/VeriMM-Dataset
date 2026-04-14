module top_module(
        input [2:1] y,
        input w,
        output reg Z1);always_comb begin
		case ({y, w})
			3'b000: Z1 = 1'b1;
			3'b001: Z1 = 1'b0;
			3'b010: Z1 = 1'b0;
			3'b011: Z1 = 1'b1;
			3'b100: Z1 = 1'b1;
			3'b101: Z1 = 1'b0;
			default: Z1 = 1'bx;
		endcase
	end
	
endmodule