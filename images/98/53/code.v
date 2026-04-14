module top_module(clk,rst,div,clkd,clk_1kHz);input wire clk,rst; 
 input wire [10:0]div; 
 output wire clkd; 
 output wire clk_1kHz; 
 reg [10:0]q = 0; 
 reg cd = 0; 
 reg [15:0]q_1kHz = 0; 
 reg cd_1kHz = 0; 
 always@(posedge clk, posedge rst) 
  if (rst) 
  begin 
  q <= 0; 
  cd <=0; 
  end 
  else 
  if (q==div) 
  begin 
  q <= 0; 
  cd <= ~cd; 
  end 
  else 
  q <= q + 11'b1; 
 assign clkd = cd; 
 always@(posedge clk, posedge rst) 
  if (rst) 
  begin 
  q_1kHz <= 0; 
  cd_1kHz <=0; 
  end 
  else 
  if (q_1kHz==16'd49999) 
  begin 
  q_1kHz <= 0; 
  cd_1kHz <= ~cd_1kHz; 
  end 
  else 
  q_1kHz <= q_1kHz + 16'b1; 
 assign clk_1kHz = cd_1kHz; 
 endmodule