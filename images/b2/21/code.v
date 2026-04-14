module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w4096,
    w4095,
    w256,
    w3839,
    w15356,
    w11517,
    w16,
    w11533,
    w128,
    w11405;

  assign w1 = i_data0;
  assign w11405 = w11533 - w128;
  assign w11517 = w15356 - w3839;
  assign w11533 = w11517 + w16;
  assign w128 = w1 << 7;
  assign w15356 = w3839 << 2;
  assign w16 = w1 << 4;
  assign w256 = w1 << 8;
  assign w3839 = w4095 - w256;
  assign w4095 = w4096 - w1;
  assign w4096 = w1 << 12;

  assign o_data0 = w11405;

  
endmodule