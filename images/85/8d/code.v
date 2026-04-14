module top_module(q, t, clk, ena, clr, pre );input t,clk,ena,clr,pre; 
  output q; 
  reg q; 
  reg clk_pre; 
  initial q = 1'b0; 
  always@ (clk or clr or pre) 
  begin 
  if (clr == 1'b1) 
  q <= 1'b0; 
  else if (pre == 1'b1) 
  q <= 1'b1; 
  else if ((clk == 1'b1) && (clk_pre == 1'b0)) 
  begin 
  if (ena == 1'b1) 
  begin 
  if (t == 1'b1) 
  q <= ~q; 
  end 
  end 
  clk_pre <= clk; 
  end 
 endmodule