module top_module(input clk,input cein,output ceout);reg q; 
  initial q = 0; 
  assign ceout = cein & q; 
  always @(posedge clk) begin 
  if(cein) 
  q = ~q; 
  end 
 endmodule