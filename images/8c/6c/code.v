module top_module(
	input clk,
	input pause,
	output reg [11:0] count);
always @(posedge clk) begin
	if (!pause)
		count <= count + 1;
end
	
endmodule