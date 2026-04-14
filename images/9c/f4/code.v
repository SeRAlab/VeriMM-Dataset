module top_module(
    S,
    A,
    B,
    Y
);input S;
  input A, B;
  output reg Y;

  always @(*) Y = (S) ? B : A;
endmodule