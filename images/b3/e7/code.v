module top_module (
	input e1,
	input e2,
	input e3,
	input e4,
	output reg e_out);assign e_out = (~(e1 & e2 & e3)) & e4;
endmodule