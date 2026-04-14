module top_module(clk,xvecin,xvecout);input clk; 
  input wire [1:0] xvecin; 
  output wire [1:0] xvecout; 
  assign xvecout = {xvecin[0], clk}; 
 endmodule