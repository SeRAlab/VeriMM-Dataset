module top_module(d, ena, clrn, prn, q);input d, ena, clrn, prn; 
  output q; 
  reg q; 
  initial q = 1'b0; 
  always@ (d or ena or clrn or prn) 
  begin 
  if (clrn == 1'b0) 
  q <= 1'b0; 
  else if (prn == 1'b0) 
  q <= 1'b1; 
  else if (ena) 
  q <= d; 
  end 
 endmodule