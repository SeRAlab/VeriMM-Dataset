module top_module (
	input clk,
	input en,
	input rst,
	output reg [6:0] count);always @(posedge clk) begin
	if (rst)
		count <= 7'b1111111;
	else if (en)
		count <= count - 1;
end

endmodule