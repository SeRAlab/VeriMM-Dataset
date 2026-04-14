module top_module(
  input [31:0] i_data0,
  output [31:0] o_data0
);wire [31:0] w1 = i_data0;
  wire [31:0] w4096 = w1 << 12;
  wire [31:0] w4095 = w4096 - w1;
  wire [31:0] w256 = w1 << 8;
  wire [31:0] w4351 = w4095 + w256;
  wire [31:0] w1024 = w1 << 10;
  wire [31:0] w5375 = w4351 + w1024;
  wire [31:0] w21500 = w5375 << 2;
  wire [31:0] w26875 = w5375 + w21500;

  assign o_data0 = w26875;

endmodule