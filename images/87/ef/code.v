module fsm_next_state(
        input [1:0] t,
        input f,
        output reg T);
	
	always_comb begin
		case ({t, f})
			3'b000: T = 1'b1;
			3'b001: T = 1'b1;
			3'b010: T = 1'b0;
			3'b011: T = 1'b0;
			3'b100: T = 1'b1;
			3'b101: T = 1'b0;
			3'b110: T = 1'b0;
			3'b111: T = 1'b1;
			default: T = 1'bx;
		endcase
	end
	
endmodule