module top_module(
	input clk,
	input [3:0] data_in,
	output reg [3:0] data_out);always @(posedge clk) begin
	data_out <= {data_out[2:0], data_in[3]};
end
endmodule