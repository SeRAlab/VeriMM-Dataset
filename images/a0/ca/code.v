module top_module (
	input clk,
	input rst,
	input dir,
	output reg [8:0] count);always @(posedge clk) begin
	if (rst)
		count <= 9'b000000000;
	else if (dir)
		count <= count + 1;
	else
		count <= count - 1;
end

endmodule