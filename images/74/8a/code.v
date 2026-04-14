module top_module(in1, in2, cin, res);input [15:0] in1;
  input [15:0] in2;
  input cin;
  output [16:0] res;
  wire [15:0] sum;
  wire cout;

  // Add the inputs and carry-in to produce the sum
  assign sum = in1 + in2 + cin;

  // Extract the MSB of the sum to produce the carry-out
  assign cout = sum[15];

  // Combine the sum and carry-out to produce the result
  assign res = {cout, sum};

endmodule