module top_module(clk, level, O);parameter N = 16; 
  input wire clk; 
  input wire [N-1:0] level; 
  output wire O; 
  reg [N+1:0] sigma = 0; 
  assign O = ~sigma[N+1]; 
  always @(posedge clk) sigma <= sigma + {O,O,level}; 
 endmodule