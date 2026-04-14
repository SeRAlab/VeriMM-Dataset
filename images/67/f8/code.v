module top_module(
    input [31:0] data_in,
    output [31:0] data_out
);wire [31:0] w1;
  wire [31:0] w256;
  wire [31:0] w255;
  wire [31:0] w32;
  wire [31:0] w223;
  wire [31:0] w7136;
  wire [31:0] w7137;

  assign w1 = data_in;
  assign w256 = w1 << 8;
  assign w255 = 256 - w1;
  assign w32 = w1 << 5;
  assign w223 = w255 - w32;
  assign w7136 = w223 << 5;
  assign w7137 = w1 + w7136;
  assign data_out = w7137;

endmodule