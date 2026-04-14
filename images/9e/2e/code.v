module top_module(input in_clk,input [15:0] divider_factor,output reg out_clk);reg [31:0] m; 
  reg [31:0] divider; 
  reg [31:0] half_divider; 
  initial begin 
  m = 0; 
  divider = 2; 
  half_divider = 1; 
  end 
  always @(posedge in_clk) begin 
  if (m < divider - 1) 
  m <= m + 1; 
  else 
  m <= 0; 
  end 
  always @(in_clk) begin 
  if (divider_factor == 0) 
  out_clk <= in_clk; 
  else if (m < half_divider) 
  out_clk <= 1; 
  else 
  out_clk <= 0; 
  end 
  always @(posedge in_clk) begin 
  divider = 2**divider_factor; 
  half_divider = divider/2; 
  end 
 endmodule