module top_module(
	input clk,
	input ctrl,
	output reg [4:0] count);
always @(posedge clk) begin
	if (ctrl)
		count <= count + 1;
	else
		count <= count - 1;
end
	
endmodule