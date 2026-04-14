module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0] o_data0;

  //Multipliers:
  wire [31:0] w1;
  wire [31:0] w4;
  wire [31:0] w5;
  wire [31:0] w10240;
  wire [31:0] w10241;

  assign w1 = i_data0;
  assign w4 = w1 << 2;
  assign w5 = w1 + w4;
  assign w10240 = w5 << 11;
  assign w10241 = w1 + w10240;

  assign o_data0 = w10241;

  //multiplier_block area estimate = 2714.34246185294;
endmodule