module top_module(
  input sensor_in,
  input ref_in,
  output touched_out
);parameter sensor_type = 0; // 0 for capacitive, 1 for resistive

reg comparator_out;
reg [7:0] filter_out;
reg amplified_out;
reg thresholded_out;

// Comparator circuit
always @ (sensor_in, ref_in) begin
  if (sensor_in > ref_in) begin
    comparator_out <= 1;
  end else begin
    comparator_out <= 0;
  end
end

// Filter circuit
always @ (comparator_out) begin
  case (sensor_type)
    0: filter_out <= {filter_out[6:0], comparator_out}; // Capacitive touch sensor filter
    1: filter_out <= (filter_out + comparator_out) >> 1; // Resistive touch sensor filter
  endcase
end

// Amplifier circuit
always @ (filter_out) begin
  case (sensor_type)
    0: amplified_out <= filter_out[7]; // Capacitive touch sensor amplifier
    1: amplified_out <= filter_out[7:1]; // Resistive touch sensor amplifier
  endcase
end

// Thresholding logic
always @ (amplified_out) begin
  if (amplified_out > 127) begin
    thresholded_out <= 1;
  end else begin
    thresholded_out <= 0;
  end
end

assign touched_out = thresholded_out;

endmodule