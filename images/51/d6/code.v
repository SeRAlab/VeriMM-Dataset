module register (
	input clk,
	input reset,
	input enable_n,
	input [11:0] data_in,
	output reg [11:0] data_out
);always @(posedge clk or posedge reset) begin
	if (reset)
		data_out <= 12'b000000000000;
	else if (~enable_n)
		data_out <= data_in;
end

endmodule