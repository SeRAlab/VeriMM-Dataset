module shift_add(
  input [15:0] a,
  output [15:0] y
);

  assign y = a + (a >> 2);

endmodule