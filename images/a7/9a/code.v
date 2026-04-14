module top_module(
  input [31:0] a,
  input [31:0] b,
  output [63:0] result
);wire [31:0] a_lo;
  wire [31:0] a_hi;
  wire [31:0] b_lo;
  wire [31:0] b_hi;

  assign a_lo = a[15:0];
  assign a_hi = a[31:16];
  assign b_lo = b[15:0];
  assign b_hi = b[31:16];

  wire [63:0] p0;
  wire [63:0] p1;
  wire [63:0] p2;

  assign p0 = a_lo * b_lo;
  assign p1 = a_hi * b_lo;
  assign p2 = a_lo * b_hi;

  assign result = (p0 + (p1 << 16) + (p2 << 16)) + (a_hi * b_hi) << 32;

endmodule