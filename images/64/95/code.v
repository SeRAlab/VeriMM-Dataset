module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  //Multipliers:
  wire [31:0]
    w1,
    w16,
    w17,
    w4,
    w13,
    w6656,
    w6643,
    w16384,
    w23027;

  assign w1 = i_data0;
  assign w4 = w1 << 2; // missing multiplier
  assign w16 = w1 << 4;
  assign w16384 = w1 << 14;
  assign w17 = w1 + w16;
  assign w13 = w17 - w4; // missing multiplier
  assign w6656 = w13 << 9;
  assign w6643 = w6656 - w13;
  assign w23027 = w6643 + w16384;
  
  assign o_data0 = w23027;

  //multiplier_block area estimate = 5791.26237074559;
endmodule