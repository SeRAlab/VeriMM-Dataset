module top_module (
	input clk,
	input up,
	output reg [2:0] count);always @(posedge clk) begin
	if (up)
		count <= count + 1;
	else
		count <= count - 1;
end

endmodule