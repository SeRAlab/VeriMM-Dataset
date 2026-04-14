module top_module(out, i0, i1, i2, i3, s1, s0);output out;
input i0, i1, i2, i3;
input s1, s0;

assign out = s1 ? (s0 ? i3 : i2) : (s0 ? i1 : i0);

endmodule