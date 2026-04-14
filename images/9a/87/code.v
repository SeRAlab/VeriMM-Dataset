module top_module(
  input [11:0] ambient_light,
  input enable,
  input [2:0] brightness_level,
  input clk, // Added clk input
  output [11:0] light_output,
  output reg dim_up,
  output reg dim_down
);reg [11:0] pwm_counter;
  reg [11:0] pwm_threshold;
  reg [2:0] current_brightness_level;
  reg [2:0] target_brightness_level;
  reg [11:0] current_light_output;
  
  parameter PWM_PERIOD = 4095; // PWM period for 12-bit resolution
  
  always @(*) begin
    if (enable) begin
      if (ambient_light > brightness_level) begin
        target_brightness_level = brightness_level;
        dim_up = 0;
        dim_down = 1;
      end else begin
        target_brightness_level = ambient_light;
        dim_up = 1;
        dim_down = 0;
      end
    end else begin
      target_brightness_level = 0;
      dim_up = 0;
      dim_down = 0;
    end
  end
  
  always @(posedge clk) begin
    if (enable) begin
      if (current_brightness_level < target_brightness_level) begin
        current_brightness_level <= current_brightness_level + 1;
      end else if (current_brightness_level > target_brightness_level) begin
        current_brightness_level <= current_brightness_level - 1;
      end
      
      pwm_counter <= pwm_counter + 1;
      if (pwm_counter >= PWM_PERIOD) begin
        pwm_counter <= 0;
        pwm_threshold <= current_brightness_level;
      end
      
      if (pwm_counter < pwm_threshold) begin
        current_light_output <= 4095;
      end else begin
        current_light_output <= 0;
      end
    end else begin
      current_brightness_level <= 0;
      pwm_counter <= 0;
      pwm_threshold <= 0;
      current_light_output <= 0;
    end
  end
  
  assign light_output = current_light_output;
  
endmodule