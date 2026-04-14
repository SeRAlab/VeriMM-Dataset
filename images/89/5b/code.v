module top_module(input [3:0] addr,output r, s, t, x, y, z);assign x = !(addr <= 4'b0111); 
  assign t = !(addr == 4'b1010); 
  assign s = !(addr == 4'b1011); 
  assign r = !(addr == 4'b1100); 
  assign z = !(addr == 4'b1101); 
  assign y = !(addr >= 4'b1110); 
 endmodule