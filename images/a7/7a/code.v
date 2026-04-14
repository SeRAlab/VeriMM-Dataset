module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0] o_data0;

  //Multipliers:

  wire [31:0]
    w1,
    w16384,
    w16383,
    w8192,
    w24575,
    w4,
    w5,
    w40,
    w24535;

  assign w1 = i_data0;
  assign w16384 = i_data0 << 14;
  assign w16383 = w16384 - w1;
  assign w8192 = i_data0 << 13;
  assign w24575 = w16383 + w8192;
  assign w4 = i_data0 << 2;
  assign w5 = w1 + w4;
  assign w40 = w5 << 3;
  assign w24535 = w24575 - w40;

  assign o_data0 = w24535;

  //multiplier_block area estimate = 6649.47358046471;
endmodule