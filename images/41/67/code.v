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
    w64,
    w61,
    w7808,
    w7805;

  assign w1 = i_data0;
  assign w3 = w4 - w1;
  assign w4 = w1 << 2;
  assign w61 = w64 - w3;
  assign w64 = w1 << 6;
  assign w7805 = w7808 - w3;
  assign w7808 = w61 << 7;

  assign o_data0 = w7805;

  
endmodule