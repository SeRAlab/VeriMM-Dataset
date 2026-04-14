module shift_left_enable (
	input [3:0] data,
	input clk,
	input rst,
	input en,
	output reg [3:0] q);always @(posedge clk) begin
	if (rst)
		q <= 4'b0000;
	else if (en)
		q <= {q[2:0], data[3]};
end

endmodule