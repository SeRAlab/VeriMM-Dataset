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
    w48,
    w51,
    w1632,
    w1683,
    w13464;

  assign w1 = i_data0;
  assign w13464 = w1683 << 3;
  assign w1632 = w51 << 5;
  assign w1683 = w51 + w1632;
  assign w3 = w4 - w1;
  assign w4 = w1 << 2;
  assign w48 = w3 << 4;
  assign w51 = w3 + w48;

  assign o_data0 = w13464;

  
endmodule