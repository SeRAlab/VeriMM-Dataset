module top_module(clk, rst, y);input clk, rst; 
 output y; 
 reg [3:0] counter; 
 always @(posedge clk) 
  case (1'b1) 
  rst, counter == 9: 
  counter <= 0; 
  default: 
  counter <= counter+1; 
  endcase 
 assign y = counter == 12; 
 endmodule