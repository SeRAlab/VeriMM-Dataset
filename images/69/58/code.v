module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w64,
    w65,
    w16,
    w81,
    w2592,
    w2673,
    w5346;

  assign w1 = i_data0;
  assign w16 = w1 << 4;
  assign w2592 = w81 << 5;
  assign w2673 = w81 + w2592;
  assign w5346 = w2673 << 1;
  assign w64 = w1 << 6;
  assign w65 = w1 + w64;
  assign w81 = w65 + w16;

  assign o_data0 = w5346;

  
endmodule