module top_module (
	input clk,
	input clear,
	input load,
	input [7:0] data_in,
	output reg [7:0] data_out);always @(posedge clk or posedge clear) begin
	if (clear)
		data_out <= 8'b0;
	else if (load)
		data_out <= data_in;
end

endmodule