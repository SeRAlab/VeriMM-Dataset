module top_module (
	input clk,
	input rst_n,
	output reg [4:0] count);always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		count <= 5'b11111;
	else
		count <= count - 1;
end

endmodule