module top_module(
  input [3:0] A,
  input [3:0] B,
  input M,
  output [3:0] R,
  output COUT,
  output V
);wire [4:0] temp;
  wire [3:0] B_neg;

  // Correctly calculate two's complement when M is high
  assign B_neg = M ? ~B + 1'b1 : B;
  
  // Use B_neg for addition instead of B directly
  assign temp = {1'b0, A} + {1'b0, B_neg};

  assign R = temp[3:0]; // Result is always from temp's lower 4 bits
  assign COUT = temp[4]; // Carry out is the 5th bit of temp
  assign V = (A[3] == B[3] && R[3] != A[3]) ? 1'b1 : 1'b0;

endmodule