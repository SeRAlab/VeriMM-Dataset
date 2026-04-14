module top_module(
  input clk,
  input [n-1:0] data,
  input [m-1:0] duty_cycle,
  output pwm
);parameter n = 8; // number of bits used to represent the data signal
parameter m = 16; // number of steps used to represent the duty cycle of the PWM signal

reg [m-1:0] counter;
reg pwm_reg;

always @(posedge clk) begin
  counter <= counter + 1;
  
  if (counter >= duty_cycle) begin
    pwm_reg <= 0;
  end else begin
    pwm_reg <= 1;
  end
end

assign pwm = pwm_reg & data;

endmodule