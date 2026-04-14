module shift_both_directions (
	input [3:0] data,
	input clk,
	input rst,
	input dir,
	output reg [3:0] q);always @(posedge clk) begin
	if (rst)
		q <= 4'b0000;
	else if (dir)
		q <= {q[2:0], data[3]};
	else
		q <= {data[0], q[3:1]};
end

endmodule