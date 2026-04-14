module top_module(clk, start_barra, bussy_barra, barra_y, speed, up_sync, down_sync);input clk, start_barra, up_sync, down_sync; 
  input [4:0] speed; 
  output bussy_barra; 
  output reg [9:0] barra_y; 
  reg comenzar; 
  reg [2:0]state; 
  parameter STATE_0 = 0; 
  parameter STATE_1 = 1; 
  parameter STATE_2 = 2; 
  parameter LIMIT_MAX = 429; 
  initial 
  begin 
  comenzar <= 0; 
  end 
  always@(posedge clk) 
  begin 
  case(state) 
  STATE_0: 
  begin 
  if (start_barra) 
  begin 
  comenzar <= 1; 
  state <= STATE_1; 
  end 
  end 
  STATE_1: 
  begin 
  barra_y <= barra_y - speed*up_sync; 
  barra_y <= barra_y + speed*down_sync; 
  state <= STATE_2; 
  end 
  STATE_2: 
  begin 
  if (barra_y >= LIMIT_MAX) 
  begin 
  barra_y <= LIMIT_MAX; 
  end 
  else if(barra_y <= 0) 
  begin 
  barra_y <= 0; 
  end 
  end 
  endcase 
  end 
  assign bussy_barra = ((state == STATE_0)||(state == STATE_1))&&(comenzar == 1); 
 endmodule