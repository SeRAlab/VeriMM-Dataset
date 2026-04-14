module top_module(input LED_FULL_ON,input [6:0] PWM_CHANNEL_SIGS,input PWM_TIMER_TICK,input FADE_TIMER_TICK,output reg LEDR,input CLK);reg [2:0] led_mux_select; 
  reg [2:0] led_brightness_reg; 
  initial 
  begin 
  LEDR <= 1'b0; 
  led_mux_select <= 3'h0; 
  led_brightness_reg <= 3'h0; 
  end 
  always @(posedge CLK) 
  begin 
  if (LED_FULL_ON) 
  led_brightness_reg <= 3'h7; 
  else if ((FADE_TIMER_TICK == 1) && (led_brightness_reg != 3'h0)) 
  led_brightness_reg <= led_brightness_reg - 1'b1; 
  else if (FADE_TIMER_TICK) 
  led_brightness_reg <= 3'h0; 
  end 
  always @(posedge CLK) 
  begin 
  if(PWM_TIMER_TICK) 
  led_mux_select <= led_brightness_reg; 
  end 
  always @(posedge CLK) 
  begin 
  case (led_mux_select) 
  3'b000: LEDR <= 1'b0; 
  3'b001: LEDR <= PWM_CHANNEL_SIGS[0]; 
  3'b010: LEDR <= PWM_CHANNEL_SIGS[1]; 
  3'b011: LEDR <= PWM_CHANNEL_SIGS[2]; 
  3'b100: LEDR <= PWM_CHANNEL_SIGS[3]; 
  3'b101: LEDR <= PWM_CHANNEL_SIGS[4]; 
  3'b110: LEDR <= PWM_CHANNEL_SIGS[5]; 
  3'b111: LEDR <= PWM_CHANNEL_SIGS[6]; 
  endcase 
  end 
 endmodule