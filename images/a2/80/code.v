module top_module(
	(* iopad_external_pin *)
	input PAD,
	(* clkbuf_driver *)
	output Y
);assign Y = PAD;
endmodule