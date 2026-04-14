module top_module(d, ena, q);input d, ena; 
  output q; 
  reg q; 
  initial q = 1'b0; 
  always@ (d or ena) 
  begin 
  if (ena) 
  q <= d; 
  end 
 endmodule