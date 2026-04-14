module top_module( nset, reset, Q );input nset; 
  input reset; 
  output Q ; 
  reg Q ; 
  always @(negedge nset or posedge reset) 
  begin 
  if (nset ==1'b0) Q = 1'b1; 
  else if (reset==1'b1) Q = 1'b0; 
  end 
 endmodule