module top_module(
        input [2:1] y,
        input w,
        output reg Y3);always_comb begin
		case ({y, w})
			3'b000: Y3 = 1'b0;
			3'b001: Y3 = 1'b1;
			3'b010: Y3 = 1'b0;
			3'b011: Y3 = 1'b0;
			3'b100: Y3 = 1'b1;
			3'b101: Y3 = 1'b1;
			3'b110: Y3 = 1'b1;
			3'b111: Y3 = 1'b0;
			default: Y3 = 1'bx;
		endcase
	end
	
endmodule