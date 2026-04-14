module top_module(
  input signed [n-1:0] x,
  input signed [m-1:0] h,
  output signed [n-1:0] y
);parameter n = 8; // number of samples in the transmitted signal
parameter m = 4; // number of coefficients in the channel impulse response

integer i, j;
reg signed [n-1:0] conv_result;
reg signed [n-1:0] norm_result;

// Convolution operation
always @(*) begin
  for (i = 0; i < n; i = i + 1) begin
    conv_result[i] = 0;
    for (j = 0; j < m; j = j + 1) begin
      if ((i - j) >= 0) begin
        conv_result[i] = conv_result[i] + (x[i - j] * h[j]);
      end
    end
  end
end

// Normalization step
always @(*) begin
  for (i = 0; i < n; i = i + 1) begin
    norm_result[i] = (conv_result[i] * x[i]) / conv_result[i];
  end
end

// Assign equalized signal
assign y = norm_result;

endmodule