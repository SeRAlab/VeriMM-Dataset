module top_module(clock, reset, start_ball, busy_ball,actualizar_bola,revisar_bordes_bola);input clock, reset, start_ball; 
  output busy_ball; 
  output reg actualizar_bola, revisar_bordes_bola; 
  reg [2:0] state; 
  parameter STATE_0 = 0; 
  parameter STATE_1 = 1; 
  parameter STATE_2 = 2; 
  parameter STATE_3 = 3; 
  initial 
  begin 
  state <= STATE_0; 
  actualizar_bola <= 1'b0; 
  revisar_bordes_bola <= 1'b0; 
  end 
  always@(posedge clock or posedge reset) 
  begin 
  if(reset) 
  begin 
  state <= STATE_0; 
  actualizar_bola <= 1'b0; 
  revisar_bordes_bola <= 1'b0; 
  end 
  else 
  begin 
  case(state) 
  STATE_0: 
  begin 
  if (start_ball) 
  begin 
  state <= STATE_1; 
  end 
  end 
  STATE_1: 
  begin 
  actualizar_bola <= 1'b1; 
  state <= STATE_2; 
  end 
  STATE_2: 
  begin 
  actualizar_bola <= 1'b0; 
  revisar_bordes_bola <= 1'b1; 
  state <= STATE_3; 
  end 
  STATE_3: 
  begin 
  revisar_bordes_bola <= 1'b0; 
  state <= STATE_0; 
  end 
  default: 
  begin 
  state <= STATE_0; 
  end 
  endcase 
  end 
  end 
  assign busy_ball = !(state == STATE_0); 
 endmodule