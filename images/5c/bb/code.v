module counter_with_load (
	input clk,
	input reset,
	input load,
	input [9:0] data,
	output reg [9:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 10'b0000000000;
		else if (load)
			count <= data;
		else
			count <= count + 1;
	end
	
endmodule