module top_module (
	input e,
	input f,
	output reg q);assign q = ~(e | ~f);
endmodule