module top_module(H, S);input S; 
  output [0:6] H; 
  assign H[0] = ~S; 
  assign H[2] = ~S; 
  assign H[3] = ~S; 
  assign H[5] = ~S; 
  assign H[6] = ~S; 
  assign H[1] = 1; 
  assign H[4] = 1; 
 endmodule