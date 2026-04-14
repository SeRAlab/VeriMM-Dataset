module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w16,
    w17,
    w4,
    w13,
    w416,
    w433,
    w3464;

  assign w1 = i_data0;
  assign w13 = w17 - w4;
  assign w16 = w1 << 4;
  assign w17 = w1 + w16;
  assign w3464 = w433 << 3;
  assign w4 = w1 << 2;
  assign w416 = w13 << 5;
  assign w433 = w17 + w416;

  assign o_data0 = w3464;

  
endmodule