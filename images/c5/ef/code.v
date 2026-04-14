module binary_op (
  input [3:0] A,
  output [3:0] B
);

  wire is_multiple_of_3 = ((A[1:0] + A[3:2]) % 3) == 0;
  wire add_one = ~is_multiple_of_3;
  
  assign B = is_multiple_of_3 ? (A >> 2) : (A + 1);

endmodule