module top_module(
  input clock,
  input ctrl,
  input reset,
  input [15:0] period,
  output pwm_out
);reg [15:0] count;
  reg pwm_reg;

  always @(posedge clock) begin
    if (reset) begin
      count <= 0;
      pwm_reg <= 0;
    end else begin
      count <= count + 1;
      if (count >= period) begin
        count <= 0;
      end
      if (count < ctrl * period / 100) begin
        pwm_reg <= 1;
      end else begin
        pwm_reg <= 0;
      end
    end
  end

  assign pwm_out = pwm_reg;

endmodule