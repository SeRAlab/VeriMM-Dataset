module top_module(a, b, ci, co, s);input a, b, ci;
  output co, s;

  wire x;

  assign x = a^b;
  assign co = (ci & x)|(b & ~x);
  assign s = ci^x;endmodule