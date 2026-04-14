module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w16384,
    w16383,
    w32,
    w33,
    w4,
    w37,
    w2368,
    w14015;

  assign w1 = i_data0;
  assign w14015 = w16383 - w2368;
  assign w16383 = w16384 - w1;
  assign w16384 = w1 << 14;
  assign w2368 = w37 << 6;
  assign w32 = w1 << 5;
  assign w33 = w1 + w32;
  assign w37 = w33 + w4;
  assign w4 = w1 << 2;

  assign o_data0 = w14015;

  
endmodule