module top_module(
        input [1:0] y,
        input s,
        output reg Z);
	
	always_comb begin
		case ({y, s})
			3'b000: Z = 1'b0;
			3'b001: Z = 1'b1;
			3'b010: Z = 1'b1;
			3'b011: Z = 1'b0;
			3'b100: Z = 1'b0;
			3'b101: Z = 1'b1;
			default: Z = 1'bx;
		endcase
	end
	
endmodule