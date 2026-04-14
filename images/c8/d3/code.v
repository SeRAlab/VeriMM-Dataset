module binary_adder (
  input [3:0] A,
  input [3:0] B,
  input C_in,
  output [3:0] S
);

  wire [3:0] sum_wire;

  assign sum_wire = A + B + C_in;

  assign S = sum_wire;

endmodule