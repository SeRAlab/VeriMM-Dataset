module top_module (
        input clk,
        input areset,
        input button,
        input timer_done,
        output reg walk);parameter DontWalk=1'b0, Walk=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= DontWalk;
		else begin
			case (state)
				DontWalk: state <= button ? Walk : DontWalk;
				Walk: state <= timer_done ? DontWalk : Walk;
			endcase
		end
	end
	
	assign walk = (state == Walk);
	
endmodule