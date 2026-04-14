module doorbell (
        input clk,
        input areset,
        input button_pressed,
        input ring_duration_elapsed,
        output reg ring);parameter Idle=1'b0, Ring=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Idle;
		else begin
			case (state)
				Idle: state <= button_pressed ? Ring : Idle;
				Ring: state <= ring_duration_elapsed ? Idle : Ring;
			endcase
		end
	end
	
	assign ring = (state == Ring);
	
endmodule