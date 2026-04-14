module top_module(
        input [1:0] z,
        input k,
        output reg Z);

	always_comb begin
		case ({z, k})
			3'b000: Z = 1'b1;
			3'b001: Z = 1'b0;
			3'b010: Z = 1'b1;
			3'b011: Z = 1'b0;
			3'b100: Z = 1'b0;
			3'b101: Z = 1'b1;
			3'b110: Z = 1'b0;
			3'b111: Z = 1'b1;
			default: Z = 1'bx;
		endcase
	end
	
endmodule