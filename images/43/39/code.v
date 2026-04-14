module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w2048,
    w2047,
    w16,
    w15,
    w16376,
    w18423,
    w3840,
    w22263;

  assign w1 = i_data0;
  assign w15 = w16 - w1;
  assign w16 = w1 << 4;
  assign w16376 = w2047 << 3;
  assign w18423 = w2047 + w16376;
  assign w2047 = w2048 - w1;
  assign w2048 = w1 << 11;
  assign w22263 = w18423 + w3840;
  assign w3840 = w15 << 8;

  assign o_data0 = w22263;

  
endmodule