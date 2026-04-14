module top_module(output [7:0] pwmval,input clk,input pwmldce,input [7:0] wrtdata);reg [7:0] pwmreg = 8'h00; 
  assign pwmval = pwmreg; 
  always@(posedge clk) begin 
  if(pwmldce) begin 
  pwmreg <= wrtdata; 
  end 
  end 
 endmodule