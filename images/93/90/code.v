module top_module( PIN2, GIN1, GIN2, GOUT );input PIN2; 
  input GIN1; 
  input GIN2; 
  output GOUT; 
  assign GOUT = ~ (GIN2 | (PIN2 & GIN1)); 
 endmodule