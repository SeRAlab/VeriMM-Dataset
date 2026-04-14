module top_module(
  output Q,
  input S,
  input A,
  input B
);assign Q = S ? B : A;
endmodule