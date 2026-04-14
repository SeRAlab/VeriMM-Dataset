module counter_inc_module (
	input clk,
	input inc, 
	output reg [2:0] cnt);always @(posedge clk)
		if (inc)
			cnt <= cnt + 1;
		else
			cnt <= cnt;

endmodule