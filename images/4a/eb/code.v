module top_module (
	input clk,
	input trigger,
	output reg pulse);reg [1:0] pulse_state;

always @(posedge clk) begin
		if (trigger)
			pulse_state <= 2'b11;
		else if (pulse_state != 2'b00)
			pulse_state <= pulse_state - 1;
		pulse <= pulse_state[1];
	end
	
endmodule