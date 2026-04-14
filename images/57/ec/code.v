module top_module(
  input [3:0] bcd,
  output [7:0] bin
);// Lookup table for BCD to binary conversion
  // Each entry represents the binary equivalent of the BCD code
  // For example, 0000 (BCD for decimal 0) maps to 0000 (binary for decimal 0)
  // and 0100 (BCD for decimal 4) maps to 0100 (binary for decimal 4)
  // The table is defined as a parameter to make it easier to modify
  parameter [15:0] BCD_to_Bin_LUT = 16'b0000000000010001;

  // Convert each decimal digit in the BCD code to its binary equivalent
  // by using the lookup table
  wire [3:0] digit0_bin = BCD_to_Bin_LUT[bcd[3:0]];
  wire [3:0] digit1_bin = BCD_to_Bin_LUT[bcd[7:4]];

  // Combine the binary codes for each decimal digit to create the
  // eight-bit binary code output
  assign bin = {digit1_bin, digit0_bin};

endmodule