module top_module(
  input touch_signal,
  input ref_signal,
  input threshold,
  output touch_detected
);reg voltage_diff;
  
  always @(touch_signal, ref_signal) begin
    voltage_diff = touch_signal - ref_signal;
  end
  
  assign touch_detected = (voltage_diff > threshold) ? 1'b1 : 1'b0;

endmodule