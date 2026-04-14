module top_module(input [4:0] X, output [7:0] Yout);reg [6:0] Y; 
 always @* 
 begin 
  case(X) 
  0: Y = 7'h05; 
  1: Y = 7'h7F; 
  2: Y = 7'h0A; 
  3: Y = 7'h01; 
  4: Y = 7'h14; 
  5: Y = 7'h02; 
  6: Y = 7'h28; 
  7: Y = 7'h03; 
  8: Y = 7'h50; 
  9: Y = 7'h04; 
  10: Y = 7'h1E; 
  11: Y = 7'h05; 
  12: Y = 7'h07; 
  13: Y = 7'h06; 
  14: Y = 7'h0D; 
  15: Y = 7'h07; 
  16: Y = 7'h06; 
  17: Y = 7'h08; 
  18: Y = 7'h0C; 
  19: Y = 7'h09; 
  20: Y = 7'h18; 
  21: Y = 7'h0A; 
  22: Y = 7'h30; 
  23: Y = 7'h0B; 
  24: Y = 7'h60; 
  25: Y = 7'h0C; 
  26: Y = 7'h24; 
  27: Y = 7'h0D; 
  28: Y = 7'h08; 
  29: Y = 7'h0E; 
  30: Y = 7'h10; 
  31: Y = 7'h0F; 
  endcase 
 end 
 assign Yout = {Y, 1'b0}; 
 endmodule