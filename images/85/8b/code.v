module top_module(
  input signed [num_bits-1:0] audio,
  input signed [num_bits-1:0] threshold,
  output reg vad
);parameter num_bits = 16;
parameter frac_bits = 8;

reg [num_bits-1:0] audio_fixed;
reg [num_bits-1:0] threshold_fixed;

assign audio_fixed = $signed({audio, {frac_bits{1'b0}}});
assign threshold_fixed = $signed({threshold, {frac_bits{1'b0}}});

always @(*) begin
  if (audio_fixed >= threshold_fixed) begin
    vad = 1'b1;
  end else begin
    vad = 1'b0;
  end
end

endmodule