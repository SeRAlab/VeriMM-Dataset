module top_module(x, y)
  /* synthesis syn_black_box black_box_pad_pin="x[31:0],y[9:0]" */;input [31:0] x;
  output [9:0] y;

  wire [22:0] fraction = x[22:0]; // Corrected width to 23 bits
  wire [7:0] exponent = x[30:23];
  wire sign = x[31];

  // Properly handling the addition for the exponent and ensuring it fits in the correct width
  wire [8:0] adjusted_exponent = exponent + 8'd127; // 8'd127 to explicitly define the width
  wire [9:0] value = {1'b0, adjusted_exponent, fraction[22:0]}; // Adjust to ensure correct width

  assign y = (sign == 1'b1) ? 10'b1111111111 : value[9:0]; // Use corrected value
endmodule