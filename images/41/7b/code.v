module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w256,
    w257,
    w8224,
    w8481,
    w4096,
    w3839,
    w15356,
    w6875;

  assign w1 = i_data0;
  assign w15356 = w3839 << 2;
  assign w256 = w1 << 8;
  assign w257 = w1 + w256;
  assign w3839 = w4096 - w257;
  assign w4096 = w1 << 12;
  assign w6875 = w15356 - w8481;
  assign w8224 = w257 << 5;
  assign w8481 = w257 + w8224;

  assign o_data0 = w6875;

  
endmodule