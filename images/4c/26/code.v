module binary_counter(
	input clk,
	input reset,
	input clear,
	output reg [9:0] count);always @(posedge clk) begin
		if (reset)
			count <= 10'b0000000000;
		else if (clear)
			count <= 10'b0000000000;
		else
			count <= count + 1;
	end
	
endmodule