module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0] o_data0;

  //Multipliers:

  wire [31:0]
    w1,
    w1024,
    w1023,
    w8,
    w9,
    w144,
    w1167,
    w4668,
    w3501,
    w7002;

  assign w1 = i_data0;
  assign w1024 = i_data0 << 10;
  assign w1023 = w1024 - w1;
  assign w8 = i_data0 << 3;
  assign w9 = i_data0 + w8;
  assign w144 = w9 << 4;
  assign w1167 = w1023 + w144;
  assign w4668 = w1167 << 2;
  assign w3501 = w4668 - w1167;
  assign w7002 = w3501 << 1;

  assign o_data0 = w7002;

  //multiplier_block area estimate = 6795.83517920735;
endmodule