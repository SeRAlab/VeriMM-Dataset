module top_module(input rst_n,input clk,input i,output strobe);reg[1:0] cntr; 
 reg prev_i; 
 assign strobe = cntr == 1'b0; 
 always @(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin 
  cntr <= 1'b0; 
  prev_i <= 1'b0; 
  end else begin 
  if (i == prev_i) begin 
  cntr <= cntr - 1'b1; 
  end else begin 
  cntr <= 1'b1; 
  end 
  prev_i <= i; 
  end 
 end 
 endmodule