module top_module(
	input clk,
	input in,
	output reg [3:0] out);always @(posedge clk) begin
		out <= {out[2:0], in};
	end
	
endmodule