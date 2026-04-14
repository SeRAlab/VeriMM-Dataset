module top_module(input [11:0] PTX,input [11:0] PTY,input [11:0] P1X,input [11:0] P1Y,input [11:0] P2X,input [11:0] P2Y,output sin);wire signed [11:0] Sub1; 
  wire signed [11:0] Sub2; 
  wire signed [11:0] Sub3; 
  wire signed [11:0] Sub4; 
  wire signed [22:0] Sub5; 
  wire signed [22:0] Mult1; 
  wire signed [22:0] Mult2; 
  assign Sub1 = PTX - P2X; 
  assign Sub2 = P1Y - P2Y; 
  assign Sub3 = P1X - P2X; 
  assign Sub4 = PTY - P2Y; 
  assign Mult1 = Sub1 * Sub2; 
  assign Mult2 = Sub3 * Sub4; 
  assign Sub5 = Mult1 - Mult2; 
  assign sin = (Sub5 >= 0) ? 1 : 0; 
 endmodule