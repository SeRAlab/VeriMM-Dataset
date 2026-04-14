module shift_register(
	input clk,
	input shift_enable,
	input load,
	input [7:0] load_value,
	output reg [7:0] data);

always @(posedge clk) begin
	if (load)
		data <= load_value;
	else if (shift_enable)
		data <= {data[6:0], 1'b0};
end

endmodule