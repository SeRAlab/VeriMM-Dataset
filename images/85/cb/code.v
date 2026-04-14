module top_module(D,WE,clk,AW,AR,QW,QR);input [7:0] D; 
  input WE,clk; 
  input [3:0] AW; 
  input [3:0] AR; 
  output [7:0] QW; 
  output [7:0] QR; 
  reg [7:0] ram [0:15]; 
  always @ (negedge clk) if (WE) ram[AW] <= D; 
  assign QW= ram[AW]; 
  assign QR= ram[AR]; 
 endmodule