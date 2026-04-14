module top_module(
  input [31:0] a,
  input [4:0] n,
  output [31:0] b
);assign b = (n > 0) ? ((n > 31) ? 0 : ((n > 0) ? (a << n) : (a >>> -n))) : a;

endmodule