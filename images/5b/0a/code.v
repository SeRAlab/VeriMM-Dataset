module top_module(clk, rst, d, q, ena);input clk, rst, ena; 
  output q; 
  reg q; 
  input d; 
  always @(posedge clk or posedge rst) begin 
  if (rst == 1) begin 
  q <= 0; 
  end else if (ena) begin 
  q <= d; 
  end 
  end 
 endmodule