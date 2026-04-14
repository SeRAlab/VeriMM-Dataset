module parallel_load_shift_register(
	input clk,
	input reset_n,
	input load,
	input [7:0] data_in,
	output reg [7:0] data_out);always @(posedge clk or negedge reset_n) begin
	if (!reset_n)
		data_out <= 8'b0;
	else if (load)
		data_out <= data_in;
	else
		data_out <= {1'b0, data_out[7:1]};
end

endmodule