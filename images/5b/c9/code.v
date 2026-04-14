module top_module(
        input [1:0] a,
        input i,
        output reg U);
	
	always_comb begin
		case ({a, i})
			3'b000: U = 1'b1;
			3'b001: U = 1'b0;
			3'b010: U = 1'b1;
			3'b011: U = 1'b0;
			3'b100: U = 1'b0;
			3'b101: U = 1'b1;
			3'b110: U = 1'b1;
			3'b111: U = 1'b0;
			default: U = 1'bx;
		endcase
	end
	
endmodule