module multiplier (
    input   [3:0] i_data,
    output  [7:0] o_data
);

  // Declare any required wires or variables here
  wire [3:0] w1;
  wire [7:0] w20;

  // Implement the multiplier using shifts and additions
  assign w1 = i_data << 2;
  assign w20 = w1 + (i_data << 5);

  // Assign the output value to o_data
  assign o_data = w20;

endmodule