module top_module(
  input clk,
  input reset,
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter p = 2; // number of poles
parameter q = 2; // number of zeros

// Define coefficients here
parameter signed [15:0] a1 = 16'd0;
parameter signed [15:0] a2 = 16'd0;
parameter signed [15:0] b0 = 16'd0;
parameter signed [15:0] b1 = 16'd0;
parameter signed [15:0] b2 = 16'd0;

// Define difference equation function here
reg signed [15:0] y1, y2;
reg signed [15:0] x1, x2;

always @(posedge clk) begin
  if (reset) begin
    y1 <= 16'd0;
    y2 <= 16'd0;
    x1 <= 16'd0;
    x2 <= 16'd0;
  end else begin
    y1 <= (b0*in + b1*x1 + b2*x2 - a1*y1 - a2*y2) >> 16;
    y2 <= y1;
    x2 <= x1;
    x1 <= in;
  end
end

assign out[0] = y1;
assign out[1] = y2;

endmodule