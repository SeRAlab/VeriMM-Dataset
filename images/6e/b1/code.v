module top_module(output o, input i0, i1);// Intermediate wires
  wire w0;
  wire w1;
  wire w2;

  // AND gate
  and a0 (w0, i0, i1);

  // NOT gate
  not n0 (w1, i0);

  // NOT gate
  not n1 (w2, i1);

  // AND gate
  and a1 (o, w1, w2);

  // End of module
endmodule