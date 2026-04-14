module top_module(
  input signed [15:0] in1, // original signal
  input signed [15:0] in2, // echo signal
  output reg signed [15:0] out // original signal without the echo
);parameter N = 32; // filter length
  parameter mu = 0.01; // step size

  reg signed [15:0] x [0:N-1]; // input buffer
  reg signed [15:0] w [0:N-1]; // filter coefficients
  reg signed [15:0] y; // estimated echo signal
  reg signed [15:0] e; // error signal

  integer i;

  always @(in1, in2) begin
    // shift input buffer
    for (i = N-1; i > 0; i = i - 1) begin
      x[i] <= x[i-1];
    end
    x[0] <= in1;

    // calculate estimated echo signal
    y = 0;
    for (i = 0; i < N; i = i + 1) begin
      y = y + w[i] * x[i];
    end

    // calculate error signal
    e = in2 - y;

    // update filter coefficients
    for (i = 0; i < N; i = i + 1) begin
      w[i] = w[i] + mu * e * x[i];
    end

    // subtract estimated echo signal from original signal
    out = in1 - y;
  end

endmodule