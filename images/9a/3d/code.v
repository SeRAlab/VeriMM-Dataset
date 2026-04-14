module top_module(
  input [7:0] A,
  input [7:0] B,
  output [7:0] C,
  output Cout
);wire [7:0] sum;
  wire [7:0] carry;

  assign sum = A + B;
  assign carry = {1'b0, sum[7:1]};

  assign C = sum;
  assign Cout = carry[7];

endmodule