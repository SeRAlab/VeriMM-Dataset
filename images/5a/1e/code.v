module top_module(
  input [2:0] bin,
  output [2:0] gray
);wire x1, x2, x3, x4, x5, x6;

  // XOR gates
  xor(x1, bin[2], bin[1]);
  xor(x2, bin[1], bin[0]);
  xor(x3, bin[2], x1);
  xor(x4, bin[1], x2);
  xor(x5, bin[0], x4);

  // AND gates
  and(x6, x3, x5);

  assign gray = {x6, x5, x4};

endmodule