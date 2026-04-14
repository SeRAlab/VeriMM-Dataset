module top_module(in0, in1, in2, in3, sel, out);input in0, in1, in2, in3, sel;
output out;
wire not_sel, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;

not u1(not_sel, sel);
and u2(a, in0, not_sel);
and u3(b, in1, not_sel);
and u4(c, in2, sel);
and u5(d, in3, sel);
or u6(e, a, b);
or u7(f, c, d);
and u8(g, in0, sel);
and u9(h, in1, sel);
and u10(i, in2, not_sel);
and u11(j, in3, not_sel);
or u12(k, g, h);
or u13(l, i, j);
or u14(m, e, f);
and u15(n, in0, in1);
and u16(o, in2, in3);
or u17(p, n, o);
or u18(out, k, l, m, p);
endmodule