module top_module(input [5:0] bplcon2,input [2:1] nplayfield,input [7:0] nsprite,output reg sprsel);reg [2:0] sprcode; 
 wire [3:0] sprgroup; 
 wire pf1front; 
 wire pf2front; 
 assign sprgroup[0] = (nsprite[1:0]==2'd0) ? 1'b0 : 1'b1; 
 assign sprgroup[1] = (nsprite[3:2]==2'd0) ? 1'b0 : 1'b1; 
 assign sprgroup[2] = (nsprite[5:4]==2'd0) ? 1'b0 : 1'b1; 
 assign sprgroup[3] = (nsprite[7:6]==2'd0) ? 1'b0 : 1'b1; 
 always @(*) 
  if (sprgroup[0]) 
  sprcode = 3'd1; 
  else if (sprgroup[1]) 
  sprcode = 3'd2; 
  else if (sprgroup[2]) 
  sprcode = 3'd3; 
  else if (sprgroup[3]) 
  sprcode = 3'd4; 
  else 
  sprcode = 3'd7; 
 assign pf1front = sprcode[2:0]>bplcon2[2:0] ? 1'b1 : 1'b0; 
 assign pf2front = sprcode[2:0]>bplcon2[5:3] ? 1'b1 : 1'b0; 
 always @(*) 
 begin 
  if (sprcode[2:0]==3'd7) 
  sprsel = 1'b0; 
  else if (pf1front && nplayfield[1]) 
  sprsel = 1'b0; 
  else if (pf2front && nplayfield[2]) 
  sprsel = 1'b0; 
  else 
  sprsel = 1'b1; 
 end 
 endmodule