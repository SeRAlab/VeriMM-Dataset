module top_module(
  input [2:0] A,
  input [2:0] B,
  input [2:0] C,
  output reg [2:0] Y1,
  output reg [2:0] Y2,
  output reg [2:0] Y3
);assign Y1 = A & B;
  assign Y2 = A | C;
  assign Y3 = B ^ C;

endmodule