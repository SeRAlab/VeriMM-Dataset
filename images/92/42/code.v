module top_module(
	input A,
	input B,
	input C,
	output Co,
	output S
	);assign {Co, S} = C + A + B;endmodule