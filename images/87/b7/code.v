module fsm_module(
        input [1:0] s,
        input y,
        output reg W);
	
	always_comb begin
		case ({s, y})
			3'b000: W = 1'b0;
			3'b001: W = 1'b1;
			3'b010: W = 1'b0;
			3'b011: W = 1'b1;
			3'b100: W = 1'b1;
			3'b101: W = 1'b0;
			3'b110: W = 1'b0;
			3'b111: W = 1'b1;
			default: W = 1'bx;
		endcase
	end
	
endmodule