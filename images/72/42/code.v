module top_module(
        input [1:0] c,
        input p,
        output reg C);

	always_comb begin
		case ({c, p})
			3'b000: C = 1'b1;
			3'b001: C = 1'b0;
			3'b010: C = 1'b1;
			3'b011: C = 1'b0;
			3'b100: C = 1'b0;
			3'b101: C = 1'b1;
			3'b110: C = 1'b1;
			3'b111: C = 1'b0;
			default: C = 1'bx;
		endcase
	end
	
endmodule