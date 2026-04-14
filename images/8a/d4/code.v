module top_module(input clk,input rst_n,input signal_in,output reg signal_out);reg ff1,ff2; 
 always @(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin 
  ff1 <= 1'b0; 
  ff2 <= 1'b0; 
  end 
  else begin 
  ff1 <= signal_in; 
  ff2 <= ff1; 
  end 
 end 
 always @(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin 
  signal_out <= 1'b0; 
  end 
  else begin 
  if (!ff2 && ff1) 
  signal_out <= 1'b1; 
  else begin 
  signal_out <= 1'b0; 
  end 
  end 
 end 
 endmodule