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
    w2064,
    w2065,
    w8260,
    w10325,
    w16512,
    w26837,
    w32,
    w26869;

  assign w1 = i_data0;
  assign w10325 = w2065 + w8260;
  assign w128 = w1 << 7;
  assign w129 = w1 + w128;
  assign w16512 = w129 << 7;
  assign w2064 = w129 << 4;
  assign w2065 = w1 + w2064;
  assign w26837 = w10325 + w16512;
  assign w26869 = w26837 + w32;
  assign w32 = w1 << 5;
  assign w8260 = w2065 << 2;

  assign o_data0 = w26869;

  
endmodule