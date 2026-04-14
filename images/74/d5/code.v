module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w2048,
    w2049,
    w8,
    w7,
    w14,
    w2035,
    w16280,
    w14245,
    w28490;

  assign w1 = i_data0;
  assign w14 = w7 << 1;
  assign w14245 = w16280 - w2035;
  assign w16280 = w2035 << 3;
  assign w2035 = w2049 - w14;
  assign w2048 = w1 << 11;
  assign w2049 = w1 + w2048;
  assign w28490 = w14245 << 1;
  assign w7 = w8 - w1;
  assign w8 = w1 << 3;

  assign o_data0 = w28490;

  
endmodule