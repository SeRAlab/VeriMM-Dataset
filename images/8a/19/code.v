module bin2gray_2bit(
	input wire [1:0] b,
	output wire [1:0] g
);assign g = b ^ (b >> 1);
endmodule