module top_module(
	input clk,
	input reset,
	output reg [1:0] count);

always @(posedge clk) begin
	if (reset) begin
		count <= 2'b00;
	end else begin
		count <= count + 1;
	end
end

endmodule