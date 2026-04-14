module top_module(
  input in_signal,
  input ref_signal,
  input clock,
  output reg signed[15:0] error
);// Phase detector
  reg signed[15:0] phase_diff;
  always @(posedge clock) begin
    phase_diff <= in_signal - ref_signal;
  end

  // Loop filter
  reg signed[15:0] control_signal;
  always @(posedge clock) begin
    control_signal <= control_signal + (phase_diff >> 4);
  end

  // Voltage-controlled oscillator (VCO)
  reg signed[15:0] phase_shifted_ref;
  always @(posedge clock) begin
    phase_shifted_ref <= ref_signal + (control_signal >> 4);
  end

  // Mixer
  reg signed[15:0] mixed_signal;
  always @(posedge clock) begin
    mixed_signal <= in_signal * phase_shifted_ref;
  end

  // Feedback loop
  always @(posedge clock) begin
    error <= mixed_signal - ref_signal;
  end

endmodule