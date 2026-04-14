module top_module(
  input clk,
  input rst,
  input signed [n-1:0] in,
  output reg signed [m-1:0] out // changed to reg type to allow assignment
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter a = 3; // number of feedforward coefficients
parameter b = 2; // number of feedback coefficients

// Define fixed-point coefficients
parameter integer a1 = 0.5 * (1 << 16);
parameter integer a2 = 0.25 * (1 << 16);
parameter integer a3 = 0.125 * (1 << 16);
parameter integer b1 = 0.75 * (1 << 16);
parameter integer b2 = 0.25 * (1 << 16);

// Define internal signals
reg signed [m-1:0] y1;
reg signed [m-1:0] y2;
reg signed [n-1:0] x1;
reg signed [n-1:0] x2;

// Reset logic
always @(posedge clk) begin
  if (rst) begin
    y1 <= 0;
    y2 <= 0;
    x1 <= 0;
    x2 <= 0;
  end else begin
    // Shift input signals
    x2 <= x1;
    x1 <= in;
    
    // Calculate output signals
    y2 <= y1;
    y1 <= (a1 * x1) + (a2 * x2) + (a3 * x2) - (b1 * y1) - (b2 * y2);
    
    // Assign output signals
    out <= y1; // corrected to assign the entire output
  end
end

endmodule