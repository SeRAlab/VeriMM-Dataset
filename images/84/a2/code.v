module top_module(
  input [n-1:0] pwm,
  input clk,          // Added clk input
  output led
);parameter n = 1; // number of PWM signals
parameter f = 100; // frequency of the PWM signals in Hz

reg [7:0] counter = 0;
reg [n-1:0] pwm_duty_cycle = 0;
reg led_state = 0;

always @(posedge clk) begin
  counter <= counter + 1;
  
  if (counter == 0) begin
    pwm_duty_cycle <= pwm;
  end
  
  if (counter == pwm_duty_cycle) begin
    led_state <= 1;
  end else begin
    led_state <= 0;
  end
end

assign led = led_state;

endmodule