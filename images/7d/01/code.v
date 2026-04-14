module top_module(
  input clk,
  input rst,
  input signed [15:0] in,
  output reg signed [15:0] out // Changed from wire to reg
);parameter n = 1; // number of input signals
parameter m = 1; // number of output signals
parameter N = 8; // length of the filter (number of taps)

reg signed [15:0] in_buffer [0:N-1]; // input buffer
reg signed [15:0] coeff [0:N-1]; // filter coefficients
reg signed [15:0] out_buffer [0:N-1]; // output buffer
reg signed [15:0] sum; // sum of products

integer i; // loop counter

// Initialize filter coefficients
initial begin
  coeff[0] = 1;
  coeff[1] = 2;
  coeff[2] = 3;
  coeff[3] = 4;
  coeff[4] = 5;
  coeff[5] = 6;
  coeff[6] = 7;
  coeff[7] = 8;
end

// Shift input buffer and add new input
always @(posedge clk) begin
  if (rst) begin
    for (i = 0; i < N; i = i + 1) begin
      in_buffer[i] <= 0;
    end
  end else begin
    for (i = N-1; i > 0; i = i - 1) begin
      in_buffer[i] <= in_buffer[i-1];
    end
    in_buffer[0] <= in;
  end
end

// Compute output
always @(posedge clk) begin
  if (rst) begin
    sum <= 0;
    out <= 0;
  end else begin
    sum <= 0;
    for (i = 0; i < N; i = i + 1) begin
      out_buffer[i] <= in_buffer[i] * coeff[i];
      sum <= sum + out_buffer[i];
    end
    out <= sum;
  end
end

endmodule