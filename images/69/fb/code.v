module top_module(
  input [31:0] data,
  output reg [7:0] byte0,
  output reg [7:0] byte1,
  output reg [7:0] byte2,
  output reg [7:0] byte3
);assign byte0 = data[7:0];
  assign byte1 = data[15:8];
  assign byte2 = data[23:16];
  assign byte3 = data[31:24];

endmodule