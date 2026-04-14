module top_module(clk,reset,x,y,prod,ready);parameter bits = 8; 
 input clk; 
 input reset; 
 input [bits - 1:0] x; 
 input [bits - 1:0] y; 
 output reg [(bits * 2) - 1:0] prod; 
 output reg ready; 
 reg [7:0] rx; 
 reg [15:0] ry; 
 always @(posedge clk) begin 
  if (reset) begin 
  rx <= x; 
  ry <= 16'b0 + y; 
  prod <= 16'b0; 
  end else begin 
  rx <= rx >> 1; 
  ry <= ry << 1; 
  if (rx & 8'b1) begin 
  prod <= prod + ry; 
  end else begin 
  prod <= prod; 
  end 
  end 
  ready <= !rx || !ry; 
 end 
 endmodule