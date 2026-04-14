module top_module(
  input cin, a, b,
  output cout, sum,
  output p, g
);assign p = a ^ b;
  assign g = a & b;

  assign sum  =   p ^ cin;
  assign cout = ( p & cin ) | g;endmodule