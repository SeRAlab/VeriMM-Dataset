module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w4,
    w3,
    w1536,
    w1537,
    w48,
    w1489;

  assign w1 = i_data0;
  assign w1489 = w1537 - w48;
  assign w1536 = w3 << 9;
  assign w1537 = w1 + w1536;
  assign w3 = w4 - w1;
  assign w4 = w1 << 2;
  assign w48 = w3 << 4;

  assign o_data0 = w1489;

  
endmodule