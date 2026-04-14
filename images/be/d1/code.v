module top_module(
  input [n-1:0] in,
  input [m-1:0] h,
  output reg [n+m-2:0] out
);parameter n = 8; // length of input signal
parameter m = 4; // length of channel impulse response

reg [m-1:0] delay_line [0:n-1];

integer i, j;

always @(*) begin
  out = 0; // Initialize output
  for (i = 0; i < n; i = i + 1) begin
    delay_line[i][0] = in[i];
    for (j = 1; j < m; j = j + 1) begin
      delay_line[i][j] = delay_line[i][j-1];
    end
    for (j = 0; j < m; j = j + 1) begin
      out[i+j] = out[i+j] + delay_line[i][j] * h[j];
    end
  end
end

endmodule