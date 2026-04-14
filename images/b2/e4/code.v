module top_module(
  input [3:0] A,
  input [3:0] B,
  input RST,
  output [3:0] C
);assign C = RST ? 4'b0000 : A + B;

endmodule