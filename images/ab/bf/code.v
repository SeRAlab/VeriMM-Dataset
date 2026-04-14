module top_module(
  input [31:0] data_in,
  input enable,
  output [31:0] data_out
);assign data_out = enable ? (data_in & 32'hFFFF0000) : 0;

endmodule