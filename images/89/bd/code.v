module top_module(d, clk, sr, srval, q, pass_high);input wire d; 
  input wire clk; 
  output wire q; 
  input wire sr; 
  input wire srval; 
  input wire pass_high; 
  reg pass_when_high; 
  always @(*) begin 
  if(clk) 
  pass_when_high <= d; 
  if(sr) 
  pass_when_high <= srval; 
  end 
  reg pass_when_low; 
  always @(*) begin 
  if(!clk) 
  pass_when_low <= d; 
  if(sr) 
  pass_when_low <= srval; 
  end 
  assign q = pass_high ? pass_when_high : pass_when_low; 
 endmodule