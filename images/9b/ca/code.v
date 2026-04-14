module fsm_state_logic(
        input [1:0] y,
        input f,
        output reg P);
	
	always_comb begin
		case ({y, f})
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