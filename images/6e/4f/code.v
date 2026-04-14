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
    w124,
    w123,
    w31744,
    w31867;

  assign w1 = i_data0;
  assign w123 = w124 - w1;
  assign w124 = w31 << 2;
  assign w31 = w32 - w1;
  assign w31744 = w31 << 10;
  assign w31867 = w123 + w31744;
  assign w32 = w1 << 5;

  assign o_data0 = w31867;

  
endmodule