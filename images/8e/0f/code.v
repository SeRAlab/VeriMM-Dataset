module enable_module (
	input clk,
	input enable, 
	output reg [3:0] cnt);always @(posedge clk)
		if (enable)
			cnt <= cnt + 1;
		else
			cnt <= cnt;

endmodule