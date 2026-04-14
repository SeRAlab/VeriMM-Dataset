module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w32,
    w31,
    w16,
    w47,
    w7936,
    w7983,
    w31932;

  assign w1 = i_data0;
  assign w16 = w1 << 4;
  assign w31 = w32 - w1;
  assign w31932 = w7983 << 2;
  assign w32 = w1 << 5;
  assign w47 = w31 + w16;
  assign w7936 = w31 << 8;
  assign w7983 = w47 + w7936;

  assign o_data0 = w31932;

  
endmodule