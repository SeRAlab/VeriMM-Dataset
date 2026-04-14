module top_module(
        input [1:0] v,
        input e,
        output reg S);
	
	always_comb begin
		case ({v, e})
			3'b000: S = 1'b1;
			3'b001: S = 1'b0;
			3'b010: S = 1'b1;
			3'b011: S = 1'b0;
			3'b100: S = 1'b0;
			3'b101: S = 1'b1;
			3'b110: S = 1'b1;
			3'b111: S = 1'b0;
			default: S = 1'bx;
		endcase
	end
	
endmodule