module top_module(output reg Q, input CLK, D);parameter [0:0] INIT = 1'b0; 
  initial Q = INIT; 
  always @(posedge CLK) 
  Q <= D; 
 endmodule