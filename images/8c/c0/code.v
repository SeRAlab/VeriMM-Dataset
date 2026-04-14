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
    w16384,
    w16389,
    w80,
    w16469;

  assign w1 = i_data0;
  assign w16384 = w1 << 14;
  assign w16389 = w5 + w16384;
  assign w16469 = w16389 + w80;
  assign w4 = w1 << 2;
  assign w5 = w1 + w4;
  assign w80 = w5 << 4;

  assign o_data0 = w16469;

  
endmodule