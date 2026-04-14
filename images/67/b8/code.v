module decrementer(
	input wire [7:0] a,
	output wire [7:0] y
);assign y = a - 1;
endmodule