module tkg_c3 (output o, input i0, i1, i2);
	C3 I0 (o, i0, i1, i2);
endmodule

module C3 (output o, input i0, i1, i2);
	wire a, b, c, d, e;
	
	and (a, i0, i1);
	and (b, i0, i2);
	and (c, i1, i2);
	or (d, a, b);
	or (e, d, c);
	
	assign o = e;
endmodule