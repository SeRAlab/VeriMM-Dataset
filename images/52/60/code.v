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
    w384,
    w383,
    w1532;

  assign w1 = i_data0;
  assign w1532 = w383 << 2;
  assign w3 = w4 - w1;
  assign w383 = w384 - w1;
  assign w384 = w3 << 7;
  assign w4 = w1 << 2;

  assign o_data0 = w1532;

  
endmodule