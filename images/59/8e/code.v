module top_module(
	input clk,
	input nreset,
	output reg [7:0] q);always @(posedge clk or negedge nreset)
	if (!nreset)
		q <= 8'b00001111;
	else
		q <= {q[6:0], 1'b0};

endmodule