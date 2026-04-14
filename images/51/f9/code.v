module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [15:0] i_data0;
  output  [15:0] o_data0;

  //Multipliers:
  wire [15:0]
    w1,
    w2,
    w3,
    w4,
    w5,
    w6,
    w7,
    w8,
    w9,
    w10,
    w11,
    w12,
    w13,
    w14,
    w15,
    w16;

  assign w1 = i_data0;
  assign w2 = w1 << 1;
  assign w3 = w1 << 2;
  assign w4 = w1 << 3;
  assign w5 = w1 << 4;
  assign w6 = w1 << 5;
  assign w7 = w1 << 6;
  assign w8 = w1 << 7;
  assign w9 = w1 << 8;
  assign w10 = w1 << 9;
  assign w11 = w1 << 10;
  assign w12 = w1 << 11;
  assign w13 = w1 << 12;
  assign w14 = w1 << 13;
  assign w15 = w1 << 14;
  assign w16 = w1 << 15;

  assign o_data0 = w1 + w2 + w3 + w4 + w5 + w6 + w7 + w8 + w9 + w10 + w11 + w12 + w13 + w14 + w15 + w16;

endmodule