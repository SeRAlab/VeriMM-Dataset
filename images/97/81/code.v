module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0] o_data0;

  //Multipliers:
  wire [31:0] w1, w512, w513, w64, w449, w7184, w7633, w15266;

  // Calculate the intermediate signals using multipliers:
  assign w1 = i_data0;
  assign w512 = i_data0 << 9;
  assign w513 = i_data0 + w512;
  assign w64 = i_data0 << 6;
  assign w449 = w513 - w64;
  assign w7184 = w449 << 4;
  assign w7633 = w449 + w7184;
  assign w15266 = w7633 << 1;

  // Output signal:
  assign o_data0 = w15266;

  //multiplier_block area estimate = 4630.34883442059;
endmodule