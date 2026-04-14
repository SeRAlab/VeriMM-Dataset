module top_module(clk, ena,sel_acc,a, b,bp_ar, bp_br,bp_a, bp_b,result);input clk; 
 input ena; 
 input sel_acc; 
 input [39:0] a, b; 
 input [39:0] bp_ar, bp_br; 
 input bp_a, bp_b; 
 output [ 5:0] result; 
 reg [5:0] result; 
 reg [39:0] acc; 
 always@(posedge clk) 
  if (ena) 
  if (sel_acc) 
  acc <= bp_b ? bp_br : b; 
  else 
  acc <= bp_a ? bp_ar : a; 
 always@(posedge clk) 
  if (ena) 
  if (acc) 
  result <= 6'h1f; 
  else 
  result <= 6'h1e; 
 endmodule