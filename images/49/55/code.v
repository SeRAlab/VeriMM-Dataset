module top_module(
  output [0:31] o,
  input [0:31] i0,
  input [0:7] i1,
  input [0:7] i2,
  input [0:7] i3,
  input [0:7] i4
);wire [0:31] concatenated_input;
  wire [0:31] subtracted_value;
  wire [0:31] twos_complement;
  wire [0:31] inverted_subtracted_value;
  wire [0:31] add_one;

  assign concatenated_input = {i1, i2, i3, i4};
  assign subtracted_value = i0 - concatenated_input;

  assign twos_complement = ~subtracted_value;
  assign inverted_subtracted_value = ~subtracted_value;
  assign add_one = {1'b1, {30{1'b0}}, 1'b0};

  assign o = (subtracted_value >= 0) ? subtracted_value : (inverted_subtracted_value + add_one);

endmodule