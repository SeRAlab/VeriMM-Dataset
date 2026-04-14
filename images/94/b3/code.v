module top_module(
  input clk, // clock signal
  input [7:0] ctrl, // control signal
  output reg pwm // pulse signal with variable duty cycle
);parameter freq = 50000000; // frequency of the clock signal
parameter res = 8; // resolution of the PWM signal
parameter max_duty = 100; // maximum duty cycle of the PWM signal

reg [res-1:0] counter;
reg [7:0] duty_cycle;

always @(posedge clk) begin
  if (counter == 0) begin
    pwm <= 1;
    counter <= res-1;
  end else begin
    if (counter == duty_cycle) begin
      pwm <= 0;
    end
    counter <= counter - 1;
  end
end

always @(posedge clk) begin
  duty_cycle <= (ctrl * max_duty) / 255;
end

endmodule