module top_module(a, b, y);input a;
  input b;
  output y;

assign y = ~(a & b);
endmodule