module top_module(clk, nreset, in1, in2, dout);parameter l=2; 
  input clk, nreset; 
  input [l-1:0] in1, in2; 
  output reg dout; 
  wire cin; 
  wire [l:0] sum = in1 + in2 + cin; 
  assign cin = ~sum[l]; 
  always @(posedge clk or negedge nreset) 
  if(!nreset) 
  dout <= 0; 
  else 
  dout <= sum[l]; 
 endmodule