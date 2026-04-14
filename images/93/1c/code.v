module top_module(input [3:0] x,output [3:0] an,output [6:0] seg);assign #2 an = x; 
  assign #1 seg[6] = (x[2]&(~x[1])&(~x[0]))|((~x[3])&(~x[2])&(~x[1])&x[0]); 
  assign #1 seg[5] = (x[2]&(~x[1])&x[0])|(x[2]&x[1]&(~x[0])); 
  assign #1 seg[4] = (~x[3])&(~x[2])&x[1]&(~x[0]); 
  assign #1 seg[3] = (x[2]&(~x[1])&(~x[0]))|(x[2]&x[1]&x[0])|((~x[3])&(~x[2])&(~x[1])&x[0]); 
  assign #1 seg[2] = (x[2]&(~x[1]))|x[0]; 
  assign #1 seg[1] = (x[1]&x[0])|((~x[3])&(~x[2])&x[0])|((~x[3])&(~x[2])&x[1]); 
  assign #1 seg[0] = ((~x[3])&(~x[2])&(~x[1]))|(x[2]&x[1]&x[0]); 
 endmodule