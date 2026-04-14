module top_module(
  input [63:0] data_in,
  output [63:0] data_out
);wire [7:0] byte0, byte1, byte2, byte3, byte4, byte5, byte6, byte7;

  assign byte0 = data_in[7:0];
  assign byte1 = data_in[15:8];
  assign byte2 = data_in[23:16];
  assign byte3 = data_in[31:24];
  assign byte4 = data_in[39:32];
  assign byte5 = data_in[47:40];
  assign byte6 = data_in[55:48];
  assign byte7 = data_in[63:56];

  assign data_out = {byte7, byte6, byte5, byte4, byte3, byte2, byte1, byte0};

endmodule