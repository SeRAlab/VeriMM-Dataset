module top_module(
    i_data0,
    o_data0
);input   [31:0] i_data0;
  output  [31:0]
    o_data0;

  

  wire [31:0]
    w1,
    w128,
    w129,
    w4096,
    w4225,
    w1032,
    w3193,
    w32,
    w3161;

  assign w1 = i_data0;
  assign w1032 = w129 << 3;
  assign w128 = w1 << 7;
  assign w129 = w1 + w128;
  assign w3161 = w3193 - w32;
  assign w3193 = w4225 - w1032;
  assign w32 = w1 << 5;
  assign w4096 = w1 << 12;
  assign w4225 = w129 + w4096;

  assign o_data0 = w3161;

  
endmodule