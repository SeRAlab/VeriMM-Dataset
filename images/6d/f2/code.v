module top_module(
  input clk,
  input rst,
  input pwm_in,
  input dir,
  input [7:0] speed,
  output reg pwm_out,        // Changed from net to reg
  output reg [1:0] motor_a_b // Changed from net to reg
);reg [7:0] counter;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      counter <= 8'd0;
      pwm_out <= 1'b0;
      motor_a_b <= 2'b00;
    end else begin
      counter <= counter + 1;
      if (counter >= speed) begin
        counter <= 8'd0;
        pwm_out <= ~pwm_out;
      end
      if (dir) begin
        motor_a_b <= 2'b10;
      end else begin
        motor_a_b <= 2'b01;
      end
    end
  end

endmodule