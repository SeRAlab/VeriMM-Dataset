module top_module (
	input clk,
	input reset,
	input load,
	input [7:0] data,
	output reg [7:0] count);always @(posedge clk) begin
	if (reset)
		count <= 8'b0;
	else if (load)
		count <= data;
	else
		count <= count + 1'b1;
end

endmodule