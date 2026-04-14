module fsm_next_state_logic(
        input [1:0] u,
        input a,
        output reg R);
	
	always_comb begin
		case ({u, a})
			3'b000: R = 1'b0;
			3'b001: R = 1'b1;
			3'b010: R = 1'b0;
			3'b011: R = 1'b1;
			3'b100: R = 1'b1;
			3'b101: R = 1'b0;
			3'b110: R = 1'b0;
			3'b111: R = 1'b1;
			default: R = 1'bx;
		endcase
	end
	
endmodule