module top_module(
  input [n-1:0] rx_in,
  input [m-1:0] chan_coef,
  output [n-1:0] rx_out
);parameter n = 10; // number of received signal samples
parameter m = 5; // number of channel impulse response coefficients

reg [n-1:0] rx_temp; // temporary variable to store received signal samples
reg [m-1:0] chan_temp; // temporary variable to store channel impulse response coefficients
reg [n-1:0] rx_conv; // variable to store convolution result

integer i, j; // loop variables

always @(*) begin
  for (i = 0; i < n; i = i + 1) begin
    rx_temp[i] = rx_in[i];
    rx_conv[i] = 0;
    for (j = 0; j < m; j = j + 1) begin
      if (i >= j) begin
        chan_temp[j] = chan_coef[j];
        rx_conv[i] = rx_conv[i] + (rx_temp[i-j] * chan_temp[j]);
      end
    end
  end
end

assign rx_out = rx_conv;

endmodule