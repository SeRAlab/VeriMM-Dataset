module top_module(A, B, C, S, Cout);input [3:0] A, B;
  input C;
  output [3:0] S;
  output Cout;
  reg [3:0] temp; // temporary storage for subtraction
  wire C1, C2, C3; // carry-out for each bit
  
  // addition or subtraction
  assign temp = (C == 1) ? (~B + 1) : B;
  assign S = A + temp;
  
  // carry-out
  assign C1 = (A[0] & B[0]) | (C == 1 & temp[0]);
  assign C2 = (A[1] & B[1]) | (C1 & (A[0] | B[0])) | (C == 1 & temp[1]);
  assign C3 = (A[2] & B[2]) | (C2 & (A[1] | B[1])) | (C == 1 & temp[2]);
  assign Cout = (A[3] & B[3]) | (C3 & (A[2] | B[2])) | (C == 1 & temp[3]);
  
endmodule