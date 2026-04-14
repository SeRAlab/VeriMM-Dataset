module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w8192,
    w8193,
    w16386,
    w16387,
    w2048,
    w14339;

  assign w1 = i_data0;
  assign w14339 = w16387 - w2048;
  assign w16386 = w8193 << 1;
  assign w16387 = w1 + w16386;
  assign w2048 = w1 << 11;
  assign w8192 = w1 << 13;
  assign w8193 = w1 + w8192;

  assign o_data0 = w14339;

  
endmodule