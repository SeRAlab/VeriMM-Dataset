module top_module(
	input clk,
	input up_down,
	input clear,
	output reg [3:0] count);
always @(posedge clk) begin
	if (clear)
		count <= 0;
	else if (up_down)
		count <= count + 1;
	else
		count <= count - 1;
end
	
endmodule