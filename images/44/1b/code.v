module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w8,
    w7,
    w28672,
    w28671,
    w56,
    w28615,
    w1024,
    w27591;

  assign w1 = i_data0;
  assign w1024 = w1 << 10;
  assign w27591 = w28615 - w1024;
  assign w28615 = w28671 - w56;
  assign w28671 = w28672 - w1;
  assign w28672 = w7 << 12;
  assign w56 = w7 << 3;
  assign w7 = w8 - w1;
  assign w8 = w1 << 3;

  assign o_data0 = w27591;

  
endmodule