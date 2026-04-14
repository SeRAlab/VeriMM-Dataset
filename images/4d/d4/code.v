module top_module(
        input [1:0] e,
        input q,
        output reg E);

	always_comb begin
		case ({e, q})
			3'b000: E = 1'b1;
			3'b001: E = 1'b0;
			3'b010: E = 1'b1;
			3'b011: E = 1'b0;
			3'b100: E = 1'b0;
			3'b101: E = 1'b1;
			3'b110: E = 1'b0;
			3'b111: E = 1'b1;
			default: E = 1'bx;
		endcase
	end
	
endmodule