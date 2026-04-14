module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w512,
    w513,
    w1026,
    w1027,
    w16,
    w1011,
    w2022;

  assign w1 = i_data0;
  assign w1011 = w1027 - w16;
  assign w1026 = w513 << 1;
  assign w1027 = w1 + w1026;
  assign w16 = w1 << 4;
  assign w2022 = w1011 << 1;
  assign w512 = w1 << 9;
  assign w513 = w1 + w512;

  assign o_data0 = w2022;

  
endmodule