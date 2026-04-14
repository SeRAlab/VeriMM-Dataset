module up_down_counter(
	input clk,
	input reset,
	input up,
	input down,
	output reg [7:0] count);
always @(posedge clk) begin
	if (reset)
		count <= 8'd0;
	else if (up)
		count <= count + 1;
	else if (down)
		count <= count - 1;
end
	
endmodule