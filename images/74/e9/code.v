module shift_register_with_parallel_load (
	input clk,
	input reset,
	input shift,
	input load,
	input [15:0] data_in,
	output reg [15:0] data_out);

	always @(posedge clk) begin
		if (reset) begin
			data_out <= 16'b0;
		end else if (load) begin
			data_out <= data_in;
		end else if (shift) begin
			data_out <= {data_out[14:0], 1'b0};
		end
	end
	
endmodule