module top_module(d,q);input [5:0] d;
  output [63:0] q;
  assign q = 1'b1 << d;
endmodule