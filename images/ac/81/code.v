module top_module(clk, en, reset, d, q);parameter WIDTH=1; 
  input clk; 
  input en; 
  input reset; 
  input [WIDTH-1:0] d; 
  output [WIDTH-1:0] q; 
  reg [WIDTH-1:0] q; 
  always @ (posedge clk or posedge reset) 
  if (reset) 
  q <= 0; 
  else if (en) 
  q <= d; 
 endmodule