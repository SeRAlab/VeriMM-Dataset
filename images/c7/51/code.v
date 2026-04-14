module adder_4bit(
  input [3:0] A,
  input [3:0] B,
  input S,
  output [3:0] C
);

  assign C = S ? A - B : A + B;

endmodule