module four_bit_adder(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] sum,
  output cout
);

  wire [3:0] temp_sum;
  wire carry;

  assign temp_sum = a + b + cin;
  assign sum = temp_sum[3:0];
  assign cout = temp_sum[4];

endmodule