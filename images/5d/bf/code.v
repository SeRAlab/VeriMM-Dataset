module top_module(clk,resetn,d,squashn,en,q);input clk; 
 input resetn; 
 input en; 
 input squashn; 
 input [31:0] d; 
 output [31:0] q; 
 reg [31:0] q; 
 always @(posedge clk) 
 begin 
  if (resetn==0 || squashn==0) 
  q<=0; 
  else if (en==1) 
  q<=d; 
 end 
 endmodule