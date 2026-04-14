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
    w17408,
    w17409,
    w128,
    w17281,
    w32,
    w17249;

  assign w1 = i_data0;
  assign w128 = w1 << 7;
  assign w16 = w1 << 4;
  assign w17 = w1 + w16;
  assign w17249 = w17281 - w32;
  assign w17281 = w17409 - w128;
  assign w17408 = w17 << 10;
  assign w17409 = w1 + w17408;
  assign w32 = w1 << 5;

  assign o_data0 = w17249;

  //multiplier_block area estimate = 6612.88314944412;
endmodule