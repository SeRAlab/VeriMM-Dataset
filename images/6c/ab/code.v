module top_module(
  input signed [15:0] in,
  output signed [15:0] out1,
  output signed [15:0] out2
);// Define the mathematical formula for the Hilbert transform
  parameter PI = 3.141592653589793;
  reg signed [15:0] real_part;
  reg signed [15:0] imag_part;
  
  // Use fixed-point arithmetic to approximate cos and sin functions
  localparam [15:0] COS_PI_OVER_2 = 0;    // cos(PI/2) = 0
  localparam [15:0] SIN_PI_OVER_2 = 16'h7FFF; // sin(PI/2) = 1 (scaled to Q15 format)

  always @(*) begin
    real_part = in * COS_PI_OVER_2;
    imag_part = in * SIN_PI_OVER_2;
  end
  
  // Compute the output signals
  assign out1 = real_part;
  assign out2 = imag_part;

endmodule