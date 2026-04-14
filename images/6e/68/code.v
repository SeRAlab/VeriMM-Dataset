module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w1024,
    w1025,
    w32,
    w993,
    w31776,
    w30751,
    w3972,
    w26779;

  assign w1 = i_data0;
  assign w1024 = w1 << 10;
  assign w1025 = w1 + w1024;
  assign w26779 = w30751 - w3972;
  assign w30751 = w31776 - w1025;
  assign w31776 = w993 << 5;
  assign w32 = w1 << 5;
  assign w3972 = w993 << 2;
  assign w993 = w1025 - w32;

  assign o_data0 = w26779;

  
endmodule