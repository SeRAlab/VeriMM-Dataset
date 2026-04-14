module binary_counter(
	input clk,
	input reset,
	input enable,
	output reg [9:0] count);always @(posedge clk or posedge reset) begin
		if (reset)
			count <= 10'b0000000000;
		else if (enable)
			count <= count + 1;
	end
	
endmodule