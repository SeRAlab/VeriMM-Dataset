module top_module(
        input [1:0] b,
        input n,
        output reg B);

	always_comb begin
		case ({b, n})
			3'b000: B = 1'b1;
			3'b001: B = 1'b0;
			3'b010: B = 1'b1;
			3'b011: B = 1'b0;
			3'b100: B = 1'b1;
			3'b101: B = 1'b0;
			3'b110: B = 1'b0;
			3'b111: B = 1'b1;
			default: B = 1'bx;
		endcase
	end
	
endmodule