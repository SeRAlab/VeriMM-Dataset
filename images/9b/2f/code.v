module top_module(
        input [2:0] y,
        input x,
        output reg Z);
	
	always_comb begin
		case ({y, x})
			4'b0000: Z = 1'b0;
			4'b0001: Z = 1'b1;
			4'b0010: Z = 1'b1;
			4'b0011: Z = 1'b0;
			4'b0100: Z = 1'b1;
			4'b0101: Z = 1'b0;
			4'b0110: Z = 1'b0;
			4'b0111: Z = 1'b1;
			4'b1000: Z = 1'b0;
			4'b1001: Z = 1'b1;
			default: Z = 1'bx;
		endcase
	end
	
endmodule