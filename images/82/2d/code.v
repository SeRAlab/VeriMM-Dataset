module shift_register (
	input clk,
	input resetn,
	input [7:0] d,
	output reg [7:0] q);always @(posedge clk or negedge resetn)
		if (!resetn)
			q <= 8'b00000000;
		else
			q <= {q[6:0], d[0]};

endmodule