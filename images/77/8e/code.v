module top_module(input clk,input [9:0] xpos,input [9:0] ypos,input [1:0] button,output [4:0] LED);reg xPosLED[1:0]; 
  reg yPosLED[1:0]; 
  always@(posedge clk) 
  begin 
  if (xpos < 384) begin 
  xPosLED[0] <= 1'b1; 
  end 
  else begin 
  xPosLED[0] <= 1'b0; 
  end 
  if (xpos > 640) begin 
  xPosLED[1] <= 1'b1; 
  end 
  else begin 
  xPosLED[1] <= 1'b0; 
  end 
  if (ypos < 384) begin 
  yPosLED[1] <= 1'b1; 
  end 
  else begin 
  yPosLED[1] <= 1'b0; 
  end 
  if (ypos > 640) begin 
  yPosLED[0] <= 1'b1; 
  end 
  else begin 
  yPosLED[0] <= 1'b0; 
  end 
  end 
  assign LED[0] = button[0]|button[1]; 
  assign LED[1] = xPosLED[0]; 
  assign LED[3] = xPosLED[1]; 
  assign LED[4] = yPosLED[0]; 
  assign LED[2] = yPosLED[1]; 
 endmodule