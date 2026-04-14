module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w32,
    w33,
    w4224,
    w4225,
    w512,
    w513,
    w2052,
    w6277,
    w12554;

  assign w1 = i_data0;
  assign w12554 = w6277 << 1;
  assign w2052 = w513 << 2;
  assign w32 = w1 << 5;
  assign w33 = w1 + w32;
  assign w4224 = w33 << 7;
  assign w4225 = w1 + w4224;
  assign w512 = w1 << 9;
  assign w513 = w1 + w512;
  assign w6277 = w4225 + w2052;

  assign o_data0 = w12554;

  
endmodule