module top_module(A, B, S, Y);input A, B, S; 
 output reg Y; 
 always @* begin 
  if (S) 
  Y = B; 
  else 
  Y = A; 
 end 
 endmodule