module xor3(
  input a,
  input b,
  input c,
  output x
);

wire w1, w2, w3, w4;

not n1(a, w1);
not n2(b, w2);
not n3(c, w3);

and a1(w1, w2, w4);
and a2(w1, w3, x);
and a3(w2, w3, w1);
and a4(w1, w2, w3, w2);

or o1(w4, x, a3);

endmodule