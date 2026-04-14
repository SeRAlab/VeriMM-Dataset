module top_module(
  input [3:0] A,
  input [3:0] B,
  input C_in,
  output [3:0] S,
  output C_out
);wire [3:0] sum; // intermediate sum
  wire carry1; // carry-out from first addition
  wire carry2; // carry-out from second addition

  assign sum = A + B;
  assign {carry1, sum} = A + B + C_in; // add carry-in to sum
  assign {C_out, carry2} = carry1 + sum[3]; // add carry-out from first addition to sum

endmodule