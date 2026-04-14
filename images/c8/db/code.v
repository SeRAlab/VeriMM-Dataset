module bitwise_and_4bit (A, B, M);
  input [3:0] A, B;
  output [3:0] M;

  assign M = A & B;
endmodule