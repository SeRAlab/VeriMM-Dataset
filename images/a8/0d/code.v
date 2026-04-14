module top_module(
  input clk,
  input [n-1:0] duty_cycle,
  output pwm_out
);parameter n = 8; // number of bits used to represent the duty cycle value

reg [n-1:0] counter;
reg pwm_out_reg;

always @(posedge clk) begin
  if (counter >= (2**n)-1) begin
    counter <= 0;
    pwm_out_reg <= 1'b1;
  end else begin
    counter <= counter + 1;
    if (counter >= duty_cycle) begin
      pwm_out_reg <= 1'b0;
    end
  end
end

assign pwm_out = pwm_out_reg;

endmodule