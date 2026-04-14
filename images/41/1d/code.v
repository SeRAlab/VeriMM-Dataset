module state_module (
	input clk,
	input trigger, 
	output reg [2:0] state);always @(posedge clk)
		if (trigger)
			state <= state + 1;
		else
			state <= state;

endmodule