module top_module(D, C, R, E, Q);input D, C, R, E; 
 output reg Q; 
 always @(negedge C) begin 
  if (E == 1) begin 
  if (R == 1) 
  Q <= 1; 
  else 
  Q <= D; 
  end 
 end 
 endmodule