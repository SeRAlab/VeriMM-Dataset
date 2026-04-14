module top_module(
  input clk, // clock signal
  input reset, // reset signal
  input signed [n-1:0] in, // input signals
  output signed [m-1:0] out // output signals
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter l = 5; // number of filter taps (coefficients)

reg signed [n-1:0] delay [0:l-1]; // delay line
reg signed [n-1:0] coeffs [0:l-1]; // filter coefficients
reg signed [m-1:0] sum; // sum of products

integer i;

always @(posedge clk) begin
  if (reset) begin
    // reset delay line and sum
    for (i = 0; i < l; i = i + 1) begin
      delay[i] <= 0;
      coeffs[i] <= 0;
    end
    sum <= 0;
  end else begin
    // shift in new input value
    delay[0] <= in;
    // compute sum of products
    sum <= 0;
    for (i = 0; i < l; i = i + 1) begin
      sum <= sum + delay[i] * coeffs[i];
    end
    // shift delay line
    for (i = l-1; i > 0; i = i - 1) begin
      delay[i] <= delay[i-1];
    end
  end
end

// assign output signals
assign out = sum;

endmodule