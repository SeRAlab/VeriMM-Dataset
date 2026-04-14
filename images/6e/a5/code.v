module top_module( GIN, PHI, GOUT );input GIN; 
 input PHI; 
 output GOUT; 
  assign GOUT = ~ GIN; 
 endmodule