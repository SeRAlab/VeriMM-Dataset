module adder4 (
  input [3:0] A,
  input [3:0] B,
  output [3:0] S,
  output C
);

  wire [3:0] sum;
  wire [4:0] carry;

  assign sum = A + B;
  assign C = (sum >= 16) ? 1 : 0;
  assign S = sum[3:0];

endmodule