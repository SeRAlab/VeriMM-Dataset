module top_module(
  input voltage,
  input reset,
  input threshold,
  output reg bor_reset
);reg prev_voltage;
  
  always @(posedge voltage or posedge reset) begin
    if (reset) begin
      bor_reset <= 1;
      prev_voltage <= 0; // Initialize prev_voltage on reset
    end else begin
      if (voltage < threshold) begin
        bor_reset <= 1;
      end else if (voltage >= threshold && prev_voltage < threshold) begin
        bor_reset <= 0;
      end
      prev_voltage <= voltage;
    end
  end

endmodule