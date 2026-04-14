module top_module(
	input clk,
	input reset,
	output reg [3:0] out);always @(posedge clk or posedge reset) begin
		if (reset)
			out <= 4'b0000;
		else 
			out <= {out[2:0], ~out[3]};
	end
	
endmodule