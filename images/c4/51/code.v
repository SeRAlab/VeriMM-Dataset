module touch_sensor (
  input touch,
  output touch_detected
);

parameter t = 5; // threshold voltage of the touch sensor

assign touch_detected = (touch > t) ? 1'b1 : 1'b0;

endmodule