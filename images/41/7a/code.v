module top_module(rst, clk, din, dout);parameter N = 4;     
parameter INI = 0;   


input wire rst;
input wire clk;
input wire [N-1:0] din;
output reg [N-1:0] dout;


always @(posedge(clk))
  if (rst == 0)
    dout <= INI; 
  else
    dout <= din; 

endmodule