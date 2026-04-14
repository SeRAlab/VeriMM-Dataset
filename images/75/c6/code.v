module top_module(input CLK, D,output reg Q);initial Q = 1'b0; 
  always @(posedge CLK) 
  Q <= D; 
 endmodule