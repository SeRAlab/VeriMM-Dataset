module top_module( A, B, s, Q );input A;
  input B;
  input s;
  output Q;

  assign Q = ~( s ? A : B );endmodule