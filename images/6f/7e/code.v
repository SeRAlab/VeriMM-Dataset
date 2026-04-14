module top_module(out, in1, in2, sel);output out;

	input  in1,
		   in2,
		   sel;

	wire    out;

	assign  out = (~sel && in1) || (sel && in2);
endmodule