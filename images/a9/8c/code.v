module top_module (
	input clk,
	input reset,
	input [7:0] temp,
	input [7:0] setpoint,
	output reg heat,
	output reg cool);always @(posedge clk or posedge reset) begin
		if (reset) begin
			heat <= 0;
			cool <= 0;
		end else begin
			if (temp < setpoint) begin
				heat <= 1;
				cool <= 0;
			end else if (temp > setpoint) begin
				heat <= 0;
				cool <= 1;
			end else begin
				heat <= 0;
				cool <= 0;
			end
		end
	end
	
endmodule