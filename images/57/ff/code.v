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
    w64,
    w321,
    w5136,
    w5457;

  assign w1 = i_data0;
  assign w256 = w1 << 8;
  assign w257 = w1 + w256;
  assign w321 = w257 + w64;
  assign w5136 = w321 << 4;
  assign w5457 = w321 + w5136;
  assign w64 = w1 << 6;

  assign o_data0 = w5457;

  
endmodule