module top_module(output reg [54:0] out, input [54:0] pipeline_in, input clk);always @(posedge clk)	
	out <= pipeline_in;endmodule