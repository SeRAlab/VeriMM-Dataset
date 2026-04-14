module shift_reg_16bit (
	input clk,
	input dir,
	input [15:0] data_in,
	input load,
	output reg [15:0] q);always @(posedge clk) begin
	if (load)
		q <= data_in;
	else if (dir)
		q <= {q[14:0], 1'b0};
	else
		q <= {1'b0, q[15:1]};
end

endmodule