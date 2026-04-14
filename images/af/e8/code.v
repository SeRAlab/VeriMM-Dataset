module shift_register (
	input clk,
	input reset,
	input enable,
	output reg [6:0] data_out
);always @(posedge clk) begin
	if (reset)
		data_out <= 7'b0000000;
	else if (enable)
		data_out <= data_out >> 1;
end

endmodule