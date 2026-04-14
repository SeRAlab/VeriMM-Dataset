module top_module(A, B, C, ABn);input[2 - 1:0] A; 
  input[2 - 1:0] B; 
  output[2 - 1:0] C; 
  wire[2 - 1:0] C; 
  input ABn; 
  assign C = (ABn == 1'b1) ? A : B ; 
  endmodule