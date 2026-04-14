module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w1024,
    w1023,
    w16384,
    w15361,
    w256,
    w15617,
    w8184,
    w23801;

  assign w1 = i_data0;
  assign w1023 = w1024 - w1;
  assign w1024 = w1 << 10;
  assign w15361 = w16384 - w1023;
  assign w15617 = w15361 + w256;
  assign w16384 = w1 << 14;
  assign w23801 = w15617 + w8184;
  assign w256 = w1 << 8;
  assign w8184 = w1023 << 3;

  assign o_data0 = w23801;

  
endmodule