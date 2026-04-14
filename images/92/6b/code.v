module top_module(
  input [3:0] in,
  input [1:0] shift,
  input dir,
  output [3:0] out
);wire [3:0] shifted_right;
  wire [3:0] shifted_left;

  assign shifted_right = {2'b00, in[3:2]}; // Right shift: preserve MSB and zero fill
  assign shifted_left = {in[1:0], 2'b00};  // Left shift: take LSB and zero fill

  assign out = (dir == 0) ? (shifted_right >> shift) : (shifted_left << shift);

endmodule