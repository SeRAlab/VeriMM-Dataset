module top_module(E, D, Q);input E, D; 
 output reg Q; 
 always @* begin 
  if (E == 1) 
  Q <= D; 
 end 
 endmodule