module pedestrian_signal (
        input clk,
        input areset,
        input pedestrian_request,
        input timer_expired,
        output reg [1:0] signal);parameter DontWalk=2'b00, Walk=2'b01, Flashing=2'b10;
	reg [1:0] state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= DontWalk;
		else begin
			case (state)
				DontWalk: state <= pedestrian_request ? Walk : DontWalk;
				Walk: state <= timer_expired ? Flashing : Walk;
				Flashing: state <= timer_expired ? DontWalk : Flashing;
			endcase
		end
	end
	
	assign signal = state;
	
endmodule