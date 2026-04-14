module top_module(
        input y,
        input w,
        output reg Y0);always_comb begin
		case ({y, w})
			2'b00: Y0 = 1'b1;
			2'b01: Y0 = 1'b0;
			2'b10: Y0 = 1'b0;
			2'b11: Y0 = 1'b1;
			default: Y0 = 1'bx;
		endcase
	end
	
endmodule