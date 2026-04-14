module bitwise_and(
  input [3:0] in_data,
  output [3:0] out_data
);

  parameter const_val = 4'b1100;

  assign out_data = in_data & const_val;

endmodule