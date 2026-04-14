module top_module (
        input clk,
        input areset,
        input timer_expired,
        output reg walk_signal);parameter Walk = 1'b0, DontWalk = 1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Walk;
		else begin
			case (state)
				Walk: state <= timer_expired ? DontWalk : Walk;
				DontWalk: state <= timer_expired ? Walk : DontWalk;
			endcase
		end
	end
	
	assign walk_signal = (state == Walk);
	
endmodule