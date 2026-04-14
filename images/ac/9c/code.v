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
    w512,
    w507,
    w1280,
    w773,
    w12368,
    w11861,
    w23722;

  assign w1 = i_data0;
  assign w11861 = w12368 - w507;
  assign w12368 = w773 << 4;
  assign w1280 = w5 << 8;
  assign w23722 = w11861 << 1;
  assign w4 = w1 << 2;
  assign w5 = w1 + w4;
  assign w507 = w512 - w5;
  assign w512 = w1 << 9;
  assign w773 = w1280 - w507;

  assign o_data0 = w23722;

  
endmodule