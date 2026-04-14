module top_module (
	input clk,
	input en,
	input rst,
	output reg [2:0] count);always @(posedge clk) begin
	if (rst)
		count <= 3'b000;
	else if (en)
		count <= count + 1;
end

endmodule