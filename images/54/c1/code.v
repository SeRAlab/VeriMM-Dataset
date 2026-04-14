module top_module(
        input [2:1] y,
        input w,
        output reg Y0);always_comb begin
		case ({y, w})
			3'b000: Y0 = 1'b0;
			3'b001: Y0 = 1'b1;
			3'b010: Y0 = 1'b0;
			3'b011: Y0 = 1'b0;
			3'b100: Y0 = 1'b1;
			3'b101: Y0 = 1'b0;
			3'b110: Y0 = 1'b0;
			3'b111: Y0 = 1'b1;
			default: Y0 = 1'bx;
		endcase
	end
	
endmodule