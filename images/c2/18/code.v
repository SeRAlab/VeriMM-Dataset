module AND4_W9 (
  input [3:0] A,
  output Y
);

  wire n1, n2, n3;
  
  assign n1 = ~(A[0] & A[1]);
  assign n2 = ~(A[2] & A[3]);
  assign n3 = ~(n1 & n2);
  
  assign Y = ~n3;

endmodule