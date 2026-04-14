module top_module(out, a, b, c);output  out;
	input a, b, c;
	wire eq;
	assign eq=(a== b);
	assign out = eq? a :c;
endmodule