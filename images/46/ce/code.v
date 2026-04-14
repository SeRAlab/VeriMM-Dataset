module top_module (
        input clk,
        input areset,
        input arm_button,
        input disarm_button,
        output reg alarm);parameter Disarmed = 1'b0, Armed = 1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Disarmed;
		else begin
			case (state)
				Disarmed: state <= arm_button ? Armed : Disarmed;
				Armed: state <= disarm_button ? Disarmed : Armed;
			endcase
		end
	end
	
	assign alarm = (state == Armed);
	
endmodule