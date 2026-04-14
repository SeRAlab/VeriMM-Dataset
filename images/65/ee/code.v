module top_module(
  input touch_in,
  output led_out
);reg touch_state = 0;

  always @(touch_in) begin
    if (touch_in == 1) begin
      touch_state <= 1;
    end else begin
      touch_state <= 0;
    end
  end

  assign led_out = touch_state;

endmodule