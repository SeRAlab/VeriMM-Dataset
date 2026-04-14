module top_module(d,clk,resetn,en,q);input clk; 
 input resetn; 
 input en; 
 input [1:0] d; 
 output [1:0] q; 
 reg [1:0] q; 
 always @(posedge clk or negedge resetn) 
 begin 
  if (resetn==0) 
  q<=0; 
  else if (en==1) 
  q<=d; 
 end 
 endmodule