module top_module( 
    input wire [15:0] in,
    output wire [3:0] in1_hi, in1_lo,
    output wire [3:0] in2_hi, in2_lo,
    output wire [7:0] out );wire [7:0] in1, in2;

  // Split the 16-bit input into two 8-bit outputs
  assign in1 = in[15:8];
  assign in2 = in[7:0];

  // Split each 8-bit input into two 4-bit inputs
  assign in1_hi = in1[7:4];
  assign in1_lo = in1[3:0];
  assign in2_hi = in2[7:4];
  assign in2_lo = in2[3:0];

  // Compute the absolute difference between each pair of corresponding 4-bit inputs
  wire [3:0] abs_diff_hi, abs_diff_lo;
  assign abs_diff_hi = (in1_hi >= in2_hi) ? (in1_hi - in2_hi) : (in2_hi - in1_hi);
  assign abs_diff_lo = (in1_lo >= in2_lo) ? (in1_lo - in2_lo) : (in2_lo - in1_lo);

  // Output the sum of the absolute differences
  assign out = abs_diff_hi + abs_diff_lo;

endmodule