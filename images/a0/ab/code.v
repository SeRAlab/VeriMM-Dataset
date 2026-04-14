module top_module(
  input speech_in,
  output speech_detected
);parameter threshold = 8'h80; // threshold value for speech detection

  assign speech_detected = (speech_in >= threshold) ? 1'b1 : 1'b0;

endmodule