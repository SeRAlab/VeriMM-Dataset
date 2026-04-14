module bidirectional_shift (
	input [15:0] data,
	input clk,
	input rst,
	input dir,
	output reg [15:0] q);always @(posedge clk) begin
	if (rst)
		q <= 16'b0000000000000000;
	else if (dir)
		q <= {q[14:0], data[15]};
	else
		q <= {data[0], q[15:1]};
end

endmodule