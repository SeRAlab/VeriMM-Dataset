module top_module(
  input [N-1:0] r,
  input [L-1:0] c,
  output reg [N-1:0] e, // Change output to reg type
  input clk // Add clk input
);parameter N = 8; // number of received symbols
parameter L = 4; // length of FIR filter

reg [N-1:0] delay_line [0:L-1];
reg [N-1:0] tap_weights [0:L-1];

integer i, j;
reg [N-1:0] temp;

// Initialize tap weights
initial begin
  for (i = 0; i < L; i = i + 1) begin
    tap_weights[i] = c[i];
  end
end

// Implement FIR filter using tapped delay line
always @(*) begin
  temp = 0;
  for (j = 0; j < L; j = j + 1) begin
    temp = temp + delay_line[j] * tap_weights[j];
  end
  e = temp;
end

// Shift delay line and update with new received symbol
always @(posedge clk) begin
  for (i = L-1; i > 0; i = i - 1) begin
    delay_line[i] = delay_line[i-1];
  end
  delay_line[0] = r;
end

endmodule