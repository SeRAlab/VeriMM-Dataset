module top_module(sel, a, b, y);parameter WIDTH=8;

  input   sel;
  input   [WIDTH-1:0] a;
  input   [WIDTH-1:0] b;
  output  [WIDTH-1:0] y;

  assign #0.85 y = (sel) ? b : a;
endmodule