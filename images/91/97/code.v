module fsm_next_state(
        input [1:0] t,
        input e,
        output reg P);
	
	always_comb begin
		case ({t, e})
			3'b000: P = 1'b0;
			3'b001: P = 1'b1;
			3'b010: P = 1'b0;
			3'b011: P = 1'b1;
			3'b100: P = 1'b1;
			3'b101: P = 1'b0;
			3'b110: P = 1'b0;
			3'b111: P = 1'b1;
			default: P = 1'bx;
		endcase
	end
	
endmodule