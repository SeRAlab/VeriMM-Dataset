module top_module(
        input [1:0] s,
        input a,
        output reg P);
	
	always_comb begin
		case ({s, a})
			3'b000: P = 1'b1;
			3'b001: P = 1'b0;
			3'b010: P = 1'b1;
			3'b011: P = 1'b0;
			3'b100: P = 1'b0;
			3'b101: P = 1'b1;
			3'b110: P = 1'b1;
			3'b111: P = 1'b0;
			default: P = 1'bx;
		endcase
	end
	
endmodule