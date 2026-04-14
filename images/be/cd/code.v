module top_module(output Z, input A, B, C);wire nA, nB, nAB, nABC;

  // invert A and B using NOT gates
  not I1 (nA, A);
  not I2 (nB, B);

  // compute A & B
  and I3 (nAB, A, B);

  // compute A & B & C
  and I4 (nABC, nAB, C);

  // output Z is A & B & C (inverted to achieve AND output directly)
  assign Z = nABC;

endmodule