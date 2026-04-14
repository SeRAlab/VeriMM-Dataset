module top_module(
  input clk,
  input rst,
  input [p-1:0] mod,
  output pwm
);parameter p = 8; // number of bits used to represent the modulation signal

reg [p-1:0] counter;
reg pwm_reg;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    counter <= 0;
    pwm_reg <= 0;
  end else begin
    counter <= counter + 1;
    if (counter >= 2**p) begin
      counter <= 0;
    end
    if (counter < mod) begin
      pwm_reg <= 1;
    end else begin
      pwm_reg <= 0;
    end
  end
end

assign pwm = pwm_reg;

endmodule