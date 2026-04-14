module shift_reg (
	input clk,
	input rst,
	input d,
	output reg [3:0] q);always @(posedge clk or posedge rst) begin
	if (rst)
		q <= 4'b0000;
	else
		q <= {q[2:0], d};
end
endmodule