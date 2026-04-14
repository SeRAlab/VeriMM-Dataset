module top_module(
  input [3:0] bcd_in,
  output [7:0] bin_out
);assign bin_out = (bcd_in[3] * 8'b10000000) + (bcd_in[2] * 8'b100000) + (bcd_in[1] * 8'b1000) + (bcd_in[0] * 8'b10);

endmodule