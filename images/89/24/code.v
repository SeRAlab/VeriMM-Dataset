module top_module(
  input temp_signal,
  input fan_ctrl_signal,
  output fan_feedback_signal
);// Temperature sensing block
  reg temp_safe;
  always @ (temp_signal) begin
    if (temp_signal <= 70 && temp_signal >= 30) begin
      temp_safe = 1;
    end else begin
      temp_safe = 0;
    end
  end

  // Fan control block
  reg [7:0] fan_speed;
  always @ (temp_signal) begin
    if (temp_signal > 70) begin
      fan_speed = fan_speed + 1;
    end else if (temp_signal < 30) begin
      fan_speed = fan_speed - 1;
    end
  end
  assign fan_ctrl_signal = fan_speed;

  // Fan speed feedback signal
  assign fan_feedback_signal = fan_speed;

endmodule