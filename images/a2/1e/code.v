module top_module(
  input signed [n-1:0] in,
  input signed [m-1:0] fb,
  output reg signed [n-1:0] out, // Changed to 'reg' type to store output
  input clk // Added clk as input
);parameter n = 4; // number of input and output signals
parameter m = 3; // number of feedback signals

reg signed [m-1:0] fb_delayed [0:n-1];
reg signed [m-1:0] fb_filtered [0:n-1];

integer i; // Declare 'i' as an integer

// Delay line
always @(posedge clk) begin
  for (i = 0; i < n; i = i + 1) begin
    fb_delayed[i] <= {fb_delayed[i][m-2:0], fb}; // Note: Corrected fb array access
  end
end

// Filter
always @(posedge clk) begin
  for (i = 0; i < n; i = i + 1) begin
    fb_filtered[i] <= (fb_delayed[i][0] + fb_delayed[i][1] + fb_delayed[i][2]) / 3;
  end
end

// Subtraction
always @(posedge clk) begin
  for (i = 0; i < n; i = i + 1) begin
    out[i] <= in[i] - fb_filtered[i];
  end
end

endmodule