module parity_generator4bit(
	input [3:0] data,
	output parity);

	assign parity = data[0] ^ data[1] ^ data[2] ^ data[3];

endmodule