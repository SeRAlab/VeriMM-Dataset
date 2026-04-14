module top_module(
  input analog_in,
  input freq,
  input duty_cycle,
  output pwm_out
);parameter clock_freq = 50; // the frequency of the system clock in MHz

reg [31:0] counter;
reg pwm_out_reg;

always @(posedge freq) begin
  counter <= counter + 1;
  if (counter >= (clock_freq / freq)) begin
    counter <= 0;
    pwm_out_reg <= (counter < ((clock_freq / freq) * duty_cycle / 100));
  end
end

assign pwm_out = pwm_out_reg;

endmodule