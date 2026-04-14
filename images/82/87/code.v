module top_module(A, B, C, D, S1, S0, Y);input [3:0] A, B, C, D;
  input [1:0] S1, S0;
  output [3:0] Y;
  
  wire [3:0] Y1, Y2;
  wire not_S0, not_S1;
  
  // Implementing two 2-to-1 multiplexers
  assign not_S0 = ~S0;
  assign not_S1 = ~S1;
  
  assign Y1[0] = (not_S0 & A[0]) | (S0 & B[0]);
  assign Y1[1] = (not_S0 & A[1]) | (S0 & B[1]);
  assign Y1[2] = (not_S0 & A[2]) | (S0 & B[2]);
  assign Y1[3] = (not_S0 & A[3]) | (S0 & B[3]);
  
  assign Y2[0] = (not_S1 & C[0]) | (S1 & D[0]);
  assign Y2[1] = (not_S1 & C[1]) | (S1 & D[1]);
  assign Y2[2] = (not_S1 & C[2]) | (S1 & D[2]);
  assign Y2[3] = (not_S1 & C[3]) | (S1 & D[3]);
  
  // Implementing the 4-to-1 multiplexer
  assign Y[0] = (not_S1 & Y1[0]) | (S1 & Y2[0]);
  assign Y[1] = (not_S1 & Y1[1]) | (S1 & Y2[1]);
  assign Y[2] = (not_S1 & Y1[2]) | (S1 & Y2[2]);
  assign Y[3] = (not_S1 & Y1[3]) | (S1 & Y2[3]);
  
endmodule