module top_module(
  input signed [n-1:0] r,
  input signed [m-1:0] c,
  input clk, // Added the clock input
  output signed [n-1:0] e
);parameter n = 8; // number of received signal samples
parameter m = 4; // number of channel coefficients

reg signed [m-1:0] c_next; // next channel coefficients
reg signed [n-1:0] e_next; // next equalized signal samples

reg signed [n-1:0] r_delayed [0:n-1]; // delayed received signal samples (changed to array for proper indexing)
reg signed [n-1:0] e_delayed [0:n-1]; // delayed equalized signal samples (changed to array for proper indexing)

reg signed [m-1:0] error; // error signal

integer i, j;

always @(*) begin
  // Compute the next channel coefficients using the LMS algorithm
  for (j = 0; j < m; j = j + 1) begin
    c_next[j] = c[j] + (r_delayed[n-1] * error[j]) >> 10; // Use most recent value from delay line
  end

  // Compute the next equalized signal samples
  for (i = 0; i < n; i = i + 1) begin
    e_next[i] = 0;
    for (j = 0; j < m; j = j + 1) begin
      // Ensure index is valid and uses the correct delayed sample
      if (i - j >= 0) begin 
        e_next[i] = e_next[i] + r_delayed[i-j] * c_next[j];
      end
    end
  end
end

// Update the delayed received signal samples, delayed equalized signal samples, and error signal
always @(posedge clk) begin
  // Shift register logic for delays
  for (i = n-1; i > 0; i = i - 1) begin
    r_delayed[i] <= r_delayed[i-1];
    e_delayed[i] <= e_delayed[i-1];
  end
  r_delayed[0] <= r;
  e_delayed[0] <= e_next;
  error <= r - e_delayed[0]; // Use the most recent sample
end

// Assign the outputs
assign e = e_next;

endmodule