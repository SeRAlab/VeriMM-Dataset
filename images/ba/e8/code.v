module parallel_load_reg (
	input clk,
	input reset,
	input load_enable,
	input [7:0] d,
	output reg [7:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 8'b00000000;
		else if (load_enable)
			q <= d;
	end
	
endmodule