module top_module(
	input clk,
	input reset,
	input enable,
	input load,
	input [7:0] data_in,
	output reg [7:0] q
);always @(posedge clk) begin
		if(reset) begin
			q <= 8'b0;
		end
		else if(load) begin
			q <= data_in;
		end
		else if(enable) begin
			q <= q + 1;
		end
	end
	
endmodule