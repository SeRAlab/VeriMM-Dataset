module top_module(input clock_i,input S,input R,output Q);reg out; 
  assign Q = out; 
  always @(negedge clock_i) 
  begin 
  if( S ) 
  out <= 1'b1; 
  else 
  if( R ) 
  out <= 1'b0; 
  end 
 endmodule