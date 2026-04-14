module shift_left_async (
	input [7:0] data,
	input clk,
	input rst,
	output reg [7:0] q);always @(posedge clk or posedge rst) begin
	if (rst)
		q <= 8'b00000000;
	else
		q <= {q[6:0], data[7]};
end

endmodule