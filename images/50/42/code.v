module top_module(input clk,input clken,input i,output o);reg prev_i; 
 assign o = (prev_i == i); 
 always @(posedge clk) begin 
  if (clken) begin 
  prev_i <= i; 
  end 
 end 
 endmodule