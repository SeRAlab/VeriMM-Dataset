module pwm_generator(
  input clk,
  input rst_n,
  input [7:0] duty_cycle,
  output reg pwm_out
);

  reg [7:0] counter;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      counter <= 8'b0;
      pwm_out <= 0;
    end
    else begin
      counter <= counter + 1;
      if (counter < duty_cycle)
        pwm_out <= 1;
      else
        pwm_out <= 0;
    end
  end

endmodule