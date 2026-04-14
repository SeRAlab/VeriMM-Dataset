module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w4,
    w5,
    w160,
    w155,
    w2480,
    w2479,
    w32768,
    w30289;

  assign w1 = i_data0;
  assign w155 = w160 - w5;
  assign w160 = w5 << 5;
  assign w2479 = w2480 - w1;
  assign w2480 = w155 << 4;
  assign w30289 = w32768 - w2479;
  assign w32768 = w1 << 15;
  assign w4 = w1 << 2;
  assign w5 = w1 + w4;

  assign o_data0 = w30289;

  
endmodule