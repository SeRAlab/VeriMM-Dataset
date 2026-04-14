module top_module( 
  A, 
  Z
);input [3:0] A;
  output [3:0] Z;

  // Define constant vector B
  parameter [3:0] B = 4'b0001;

  // Perform bitwise XOR operation between A and B
  assign Z = A ^ B;

endmodule