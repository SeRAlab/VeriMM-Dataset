module register (
	input clk,
	input reset,
	input load,
	input [15:0] data_in,
	output reg [15:0] data_out);always @(posedge clk) begin
	if (reset) begin
		data_out <= 16'b0000000000000000;
	end else if (load) begin
		data_out <= data_in;
	end
end

endmodule