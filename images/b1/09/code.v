module shift_register (
	input clk,
	input reset,
	input [7:0] reset_value,
	output reg [7:0] data);

always @(posedge clk or posedge reset) begin
	if (reset)
		data <= reset_value;
	else
		data <= {data[6:0], 1'b0};
	end

endmodule