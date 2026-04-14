module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0] o_data0;

  // Wires:
  wire [31:0]
    w1,
    w2048,
    w2047,
    w4,
    w2043,
    w32,
    w2011,
    w32176,
    w30165;

  // Operations:
  assign w1 = i_data0 << 11;
  assign w2048 = i_data0 * 2048;
  assign w4 = i_data0 << 2;
  assign w2047 = w2048 - w1;
  assign w2043 = w2047 - w4;
  assign w32 = i_data0 << 5;
  assign w2011 = w2043 - w32;
  assign w32176 = w2011 << 4;
  assign w30165 = w32176 - w2011;

  // Output:
  assign o_data0 = w30165;

endmodule