module top_module(
  input [63:0] A,
  input [63:0] B,
  output [63:0] SUM,
  output CARRY
);wire [63:0] sum_partial;
  wire [63:0] carry_partial;

  assign sum_partial[0] = A[0] ^ B[0];
  assign carry_partial[0] = A[0] & B[0];

  genvar i;
  generate
    for (i = 1; i < 64; i = i + 1) begin : adder_loop
      assign sum_partial[i] = A[i] ^ B[i] ^ carry_partial[i-1];
      assign carry_partial[i] = (A[i] & B[i]) | (A[i] & carry_partial[i-1]) | (B[i] & carry_partial[i-1]);
    end
  endgenerate

  assign SUM = sum_partial;
  assign CARRY = carry_partial[63];

endmodule