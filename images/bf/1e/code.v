module top_module(
  input [n-1:0] in1,
  input [n-1:0] in2,
  output reg greater,
  output reg less,
  output reg equal
);parameter n = 8; // number of bits in the input signals

// Perform bit-wise comparison for unsigned numbers
always @(*) begin
  greater = 1'b0;
  less = 1'b0;
  equal = 1'b0;

  // Take into account the sign bit for signed numbers
  if (in1[n-1] == 1'b0 && in2[n-1] == 1'b1) begin
    greater = 1'b1;
  end else if (in1[n-1] == 1'b1 && in2[n-1] == 1'b0) begin
    less = 1'b1;
  end else if (in1[n-1] == 1'b1 && in2[n-1] == 1'b1) begin
    if (in1 > in2) begin
      greater = 1'b1;
    end else if (in1 < in2) begin
      less = 1'b1;
    end else begin
      equal = 1'b1;
    end
  end else begin
    // Handle the case where both are non-negative
    if (in1 > in2) begin
      greater = 1'b1;
    end else if (in1 < in2) begin
      less = 1'b1;
    end else begin
      equal = 1'b1;
    end
  end
end

endmodule