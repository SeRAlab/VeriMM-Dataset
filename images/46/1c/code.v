module top_module(
  input [3:0] a,
  input [3:0] b,
  output [4:0] sum
);wire [3:0] temp_sum;
  wire carry;

  // Generate the temporary sum
  assign temp_sum = a + b;

  // Detect overflow
  assign carry = (temp_sum > 4'b1111);

  // Set the fifth bit of the sum based on overflow detection
  assign sum[4] = carry;

  // Assign the lower 4 bits of the sum
  assign sum[3:0] = temp_sum;

endmodule