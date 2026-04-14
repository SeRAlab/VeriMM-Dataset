module top_module(ci, a, b, s, co);input ci;
  input a, b;
  output s;
  output co;

  assign s = a ^ b ^ ci;
  assign co = (a & b) | ((a ^ b) & ci);endmodule