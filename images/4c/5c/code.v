module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0] o_data0;

  //Multipliers:

  wire [31:0]
    w1,
    w64,
    w63,
    w4096,
    w4097,
    w4161,
    w504,
    w3657,
    w14628;

  assign w1 = i_data0;
  assign w64 = i_data0 << 6;
  assign w63 = w64 - w1;
  assign w504 = w63 << 3;
  assign w4097 = w1 + w4096;
  assign w4096 = w1 << 12;
  assign w4161 = w4097 + w64;
  assign w3657 = w4161 - w504;
  assign w14628 = w3657 << 2;

  assign o_data0 = w14628;

  //multiplier_block area estimate = 6446.56316796471;
endmodule