module sum2lsb(
  input [3:0] A,
  output [1:0] Z
);

  assign Z = A[1:0] + 2'b0;

endmodule