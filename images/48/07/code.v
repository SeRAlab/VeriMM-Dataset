module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w2048,
    w2049,
    w16,
    w2033,
    w512,
    w1521,
    w12168,
    w13689;

  assign w1 = i_data0;
  assign w12168 = w1521 << 3;
  assign w13689 = w1521 + w12168;
  assign w1521 = w2033 - w512;
  assign w16 = w1 << 4;
  assign w2033 = w2049 - w16;
  assign w2048 = w1 << 11;
  assign w2049 = w1 + w2048;
  assign w512 = w1 << 9;

  assign o_data0 = w13689;

  
endmodule