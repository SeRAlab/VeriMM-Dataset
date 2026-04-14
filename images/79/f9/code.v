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
    w4160,
    w4159,
    w260,
    w325,
    w650,
    w3509,
    w7018;

  assign w1 = i_data0;
  assign w260 = w65 << 2;
  assign w325 = w65 + w260;
  assign w3509 = w4159 - w650;
  assign w4159 = w4160 - w1;
  assign w4160 = w65 << 6;
  assign w64 = w1 << 6;
  assign w65 = w1 + w64;
  assign w650 = w325 << 1;
  assign w7018 = w3509 << 1;

  assign o_data0 = w7018;

  
endmodule