module top_module (
	input clk,
	output reg [2:0] gray);

reg [2:0] binary;

always @(posedge clk) begin
	binary <= binary + 1;
	gray <= binary ^ (binary >> 1);
end

endmodule