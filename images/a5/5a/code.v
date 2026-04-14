module shift_register(
    input clk,
    input clr,
    input d,
    output reg [31:0] q);always @(posedge clk)
	if (clr)
		q <= 32'b0;
	else
		q <= {q[30:0], d};

endmodule