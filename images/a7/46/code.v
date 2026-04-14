module top_module(a, b, sum);input [3:0] a;
   input [3:0] b;
   output [4:0] sum;
   wire [3:0] temp_sum;
   wire carry_out;
   
   // Full adder module
   // Input: a, b, carry_in
   // Output: sum, carry_out
   // This module computes the sum and carry-out of two bits, taking into account a carry-in
   // The carry-out is 1 if both inputs are 1 or if one input is 1 and the carry-in is 1
   // The sum is 1 if an odd number of inputs are 1
   // Otherwise, the sum is 0
   // This module is used to implement the binary adder
   // Note that the carry-in of the first full adder is 0
   // The carry-out of the last full adder is the carry-out of the binary adder
   // The sum of the binary adder is the concatenation of the sum outputs of the full adders
   // with the carry-out of the last full adder as the MSB
   // 
   // Truth table:
   // a | b | carry_in | sum | carry_out
   // --+---+---------+-----+----------
   // 0 | 0 |    0    |  0  |     0
   // 0 | 0 |    1    |  1  |     0
   // 0 | 1 |    0    |  1  |     0
   // 0 | 1 |    1    |  0  |     1
   // 1 | 0 |    0    |  1  |     0
   // 1 | 0 |    1    |  0  |     1
   // 1 | 1 |    0    |  0  |     1
   // 1 | 1 |    1    |  1  |     1
   
   // Implement full adder using boolean expressions
   assign temp_sum[0] = a[0] ^ b[0] ^ 1'b0;
   assign carry_out = (a[0] & b[0]) | (a[0] & 1'b0) | (b[0] & 1'b0);
   
   assign temp_sum[1] = a[1] ^ b[1] ^ carry_out;
   assign carry_out = (a[1] & b[1]) | (a[1] & carry_out) | (b[1] & carry_out);
   
   assign temp_sum[2] = a[2] ^ b[2] ^ carry_out;
   assign carry_out = (a[2] & b[2]) | (a[2] & carry_out) | (b[2] & carry_out);
   
   assign temp_sum[3] = a[3] ^ b[3] ^ carry_out;
   assign carry_out = (a[3] & b[3]) | (a[3] & carry_out) | (b[3] & carry_out);
   
   assign sum = {temp_sum, carry_out};
   
endmodule