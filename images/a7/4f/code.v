module top_module( A, B, POUT, GOUT );input A; 
  input B; 
  output POUT; 
  output GOUT; 
  assign POUT = ~ (A | B); 
  assign GOUT = ~ (A & B); 
 endmodule