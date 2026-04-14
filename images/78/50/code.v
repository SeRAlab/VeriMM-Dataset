module top_module(
  input signed [n-1:0] in,
  input signed [n-1:0] min,
  input signed [n-1:0] max,
  output reg signed [n-1:0] out // Changed to 'reg' to allow assignment
);parameter n = 16; // number of bits used to represent the input signal

// Round the input signal to the nearest integer value
integer round_val;
always @* begin
  if (in >= 0) begin
    round_val = in + 1; // Corrected to add 1 instead of 0.5 (since this is integer math)
  end else begin
    round_val = in - 1; // Corrected to subtract 1 instead of 0.5
  end
end

// Saturate the output signal to the range specified by min and max
always @* begin
  if (round_val >= max) begin
    out = max;
  end else if (round_val <= min) begin
    out = min;
  end else begin
    out = round_val;
  end
end

endmodule