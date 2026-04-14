module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0] o_data0;

  //Multipliers:
  wire [31:0] w1;
  wire [31:0] w2048;
  wire [31:0] w2049;
  wire [31:0] w16;
  wire [31:0] w2033;
  wire [31:0] w512;
  wire [31:0] w1521;
  wire [31:0] w12168;
  wire [31:0] w13689;

  assign w1 = i_data0;
  assign w2048 = i_data0 << 11;
  assign w2049 = i_data0 + w2048;
  assign w16 = i_data0 << 4;
  assign w2033 = w2049 - w16;
  assign w512 = i_data0 << 9;
  assign w1521 = w2033 - w512;
  assign w12168 = w1521 << 3;
  assign w13689 = w1521 + w12168;

  assign o_data0 = w13689;

  //multiplier_block area estimate = 6566.313589725;
endmodule