module top_module(
  input [7:0] bin_in,
  output [7:0] gray_out
);// Create a 8-bit wire to store the previous value of bin_in
  wire [7:0] prev_bin_in;
  
  // Create a 8-bit wire to store the xor of bin_in and prev_bin_in
  wire [7:0] xor_out;
  
  // Create a 8-bit wire to store the gray code output
  wire [7:0] gray_temp;
  
  // Create a 8-bit wire to store the previous value of gray_out
  wire [7:0] prev_gray_out;

  // Assign the xor output to the input xor with the previous input
  assign xor_out = bin_in ^ prev_bin_in;

  // Assign the gray code output to the xor output xor with the previous gray code output
  assign gray_temp = xor_out ^ prev_gray_out;

  // Assign the gray code output to the gray_temp
  assign gray_out = gray_temp;

  // Assign the current input to the previous input
  assign prev_bin_in = bin_in;

  // Assign the current gray code output to the previous gray code output
  assign prev_gray_out = gray_out;

endmodule