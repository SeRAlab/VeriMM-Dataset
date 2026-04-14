module shift_left_load_async (
	input [7:0] data,
	input clk,
	input rst,
	input load,
	output reg [7:0] q);always @(posedge clk or posedge rst) begin
	if (rst)
		q <= 8'b00000000;
	else if (load)
		q <= data;
	else
		q <= {q[6:0], data[7]};
end

endmodule