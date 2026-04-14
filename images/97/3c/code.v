module top_module(in0, in1, in2, in3, sel0, sel1, out);input in0, in1, in2, in3, sel0, sel1;
output out;

wire w1, w2, w3;

not(nsel0, sel0);
not(nsel1, sel1);

and(a1, in0, nsel0);
and(a2, in1, sel0);
and(a3, in2, nsel1);
and(a4, in3, sel1);

or(o1, a1, a2);
or(o2, a3, a4);

or(out, o1, o2);

endmodule