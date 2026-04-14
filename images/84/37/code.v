module top_module (
	input clk,
	input reset_n,
	input enable,
	output reg [19:0] count);always @(posedge clk) begin
	if (!reset_n)
		count <= 20'b0;
	else if (enable)
		count <= count + 1'b1;
end

endmodule