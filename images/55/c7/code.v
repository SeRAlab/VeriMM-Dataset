module top_module (
	input clk,
	input areset,
	input up,
	output [3:0] count);reg [3:0] count;
always @(posedge clk or posedge areset) begin
	if (areset)
		count <= 4'b0000;
	else if (up)
		count <= count + 1;
	else
		count <= count - 1;
end

endmodule