module top_module(A,B,Valid,C);parameter WIDTH = 32; 
  parameter CWIDTH = 2 * WIDTH; 
  input [WIDTH-1:0] A, B; 
  input Valid; 
  output [CWIDTH-1:0] C; 
  reg signed [WIDTH-1:0] A_q, B_q; 
  wire signed [CWIDTH-1:0] C_int; 
  assign C_int = A_q * B_q; 
  assign valid_int = Valid; 
  assign C = C_int; 
  always @(*) if (valid_int == 1'b1) A_q <= A; 
  always @(*) if (valid_int == 1'b1) B_q <= B; 
 endmodule