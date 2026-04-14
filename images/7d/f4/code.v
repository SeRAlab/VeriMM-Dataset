module top_module(CLK, A, B, C, D, E, F, G, H);input CLK; 
  input A; 
  input [3:0] B; 
  input [7:0] C; 
  input [31:0] D; 
  output reg E; 
  output reg [3:0] F; 
  output reg [7:0] G; 
  output reg [31:0] H; 
 always @(posedge CLK) 
 begin 
  E <= A; 
  F <= B; 
  G <= C; 
  H <= D; 
 end 
 endmodule