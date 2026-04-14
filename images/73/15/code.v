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
    w40,
    w45,
    w2560,
    w2515,
    w10060;

  assign w1 = i_data0;
  assign w10060 = w2515 << 2;
  assign w2515 = w2560 - w45;
  assign w2560 = w5 << 9;
  assign w4 = w1 << 2;
  assign w40 = w5 << 3;
  assign w45 = w5 + w40;
  assign w5 = w1 + w4;

  assign o_data0 = w10060;

  
endmodule