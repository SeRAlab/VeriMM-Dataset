module top_module(
	input clk,
	input reset,
	input load,
	input shift,
	input [3:0] data_in,
	output reg [3:0] data_out);always @(posedge clk or posedge reset) begin
	if (reset)
		data_out <= 4'b0000;
	else if (load)
		data_out <= data_in;
	else if (shift)
		data_out <= {1'b0, data_out[3:1]};
end

endmodule