module round_sat (
  input signed [15:0] signal,
  input signed [15:0] max_val,
  input signed [15:0] min_val,
  output signed [15:0] out
);

  always @(*) begin
    if (signal > max_val) begin
      out = max_val;
    end else if (signal < min_val) begin
      out = min_val;
    end else begin
      out = $signed(signal + 0.5);
    end
  end

endmodule