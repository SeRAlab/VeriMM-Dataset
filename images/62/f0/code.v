module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w512,
    w511,
    w64,
    w575,
    w2300,
    w2875;

  assign w1 = i_data0;
  assign w2300 = w575 << 2;
  assign w2875 = w575 + w2300;
  assign w511 = w512 - w1;
  assign w512 = w1 << 9;
  assign w575 = w511 + w64;
  assign w64 = w1 << 6;

  assign o_data0 = w2875;

  
endmodule