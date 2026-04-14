module synchronous_clear_register(
	input clk,
	input clear,
	input [15:0] data_in,
	output reg [15:0] data_out);always @(posedge clk) begin
	if (clear)
		data_out <= 16'b0;
	else
		data_out <= data_in;
end

endmodule