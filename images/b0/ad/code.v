module fsm_next_state(
        input [1:0] t,
        input k,
        output reg Y);
	
	always_comb begin
		case ({t, k})
			3'b000: Y = 1'b0;
			3'b001: Y = 1'b1;
			3'b010: Y = 1'b0;
			3'b011: Y = 1'b1;
			3'b100: Y = 1'b1;
			3'b101: Y = 1'b0;
			3'b110: Y = 1'b0;
			3'b111: Y = 1'b1;
			default: Y = 1'bx;
		endcase
	end
	
endmodule