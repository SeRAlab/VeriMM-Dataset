module top_module(
  input clk,
  input rst,
  input [7:0] ambient_light,
  input [7:0] brightness_level,
  output reg [7:0] brightness
);parameter max_brightness = 255; // maximum brightness level

reg [7:0] adc_output;
reg [7:0] pwm_counter;
reg [7:0] pwm_duty_cycle;

// ADC functionality
always @ (posedge clk) begin
  adc_output <= ambient_light;
end

// PWM functionality
always @ (posedge clk) begin
  if (pwm_counter < pwm_duty_cycle) begin
    brightness <= max_brightness;
  end else begin
    brightness <= 0;
  end
  
  if (pwm_counter == 255) begin
    pwm_counter <= 0;
  end else begin
    pwm_counter <= pwm_counter + 1;
  end
end

// Reset functionality
always @ (posedge clk) begin
  if (rst) begin
    brightness <= 0;
    pwm_counter <= 0;
    pwm_duty_cycle <= 0;
  end else begin
    if (adc_output > brightness_level) begin
      pwm_duty_cycle <= brightness_level;
    end else begin
      pwm_duty_cycle <= adc_output;
    end
  end
end

endmodule