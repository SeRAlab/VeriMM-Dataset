module top_module(
  input [31:0] in,
  input [4:0] shift,
  output [31:0] out_l,
  output [31:0] out_r,
  output [31:0] out_a
);assign out_l = in << shift;
  assign out_r = in >> shift;
  
  // Arithmetic shift
  assign out_a = (in[31] == 0) ? (in >> shift) : ({32{in[31]}} >> shift) | (in >> shift);

endmodule