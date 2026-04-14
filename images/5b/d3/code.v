module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w128,
    w129,
    w2048,
    w2047,
    w8256,
    w10303,
    w516,
    w9787,
    w19574;

  assign w1 = i_data0;
  assign w10303 = w2047 + w8256;
  assign w128 = w1 << 7;
  assign w129 = w1 + w128;
  assign w19574 = w9787 << 1;
  assign w2047 = w2048 - w1;
  assign w2048 = w1 << 11;
  assign w516 = w129 << 2;
  assign w8256 = w129 << 6;
  assign w9787 = w10303 - w516;

  assign o_data0 = w19574;

  
endmodule