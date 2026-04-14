module top_module(d, clk, clrn, en, q);input [31:0] d; 
 input clk, clrn, en; 
 output reg [31:0] q; 
 always @(posedge clk or negedge clrn) 
 begin 
  if (clrn == 0) 
  q <= 0; 
  else if (en) 
  q <= d; 
 end 
 endmodule