module top_module(clk, mar_we, mar_next, mar);input clk; 
  input mar_we; 
  input [31:0] mar_next; 
  output reg [31:0] mar; 
  always @(posedge clk) begin 
  if (mar_we == 1) begin 
  mar <= mar_next; 
  end 
  end 
 endmodule