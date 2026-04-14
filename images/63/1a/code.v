module top_module(a, b, y);input [1:0] a;
  input [1:0] b;
  output y;
  assign y = a == ($signed(b) >>> 1);
endmodule