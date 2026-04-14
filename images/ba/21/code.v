module shift_right_load (
	input [3:0] data,
	input clk,
	input rst,
	input load,
	output reg [3:0] q);always @(posedge clk) begin
	if (rst)
		q <= 4'b0000;
	else if (load)
		q <= data;
	else
		q <= {data[0], q[3:1]};
end

endmodule