module top_module(Z, D0, D1, S);input D0, D1, S;
  output Z;

  assign Z = (S) ? D1 : D0;

endmodule