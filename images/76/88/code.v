module top_module(
        input [1:0] t,
        input b,
        output reg Q);
	
	always_comb begin
		case ({t, b})
			3'b000: Q = 1'b1;
			3'b001: Q = 1'b0;
			3'b010: Q = 1'b1;
			3'b011: Q = 1'b0;
			3'b100: Q = 1'b0;
			3'b101: Q = 1'b1;
			3'b110: Q = 1'b1;
			3'b111: Q = 1'b0;
			default: Q = 1'bx;
		endcase
	end
	
endmodule