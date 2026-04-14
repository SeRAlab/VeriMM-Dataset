module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [31:0] i_data0;
  output  [31:0] o_data0;

  //Multipliers:
  wire [31:0] w1;
  wire [31:0] w32;
  wire [31:0] w31;
  wire [31:0] w124;
  wire [31:0] w123;
  wire [31:0] w31744;
  wire [31:0] w31867;

  assign w1 = i_data0;
  assign w32 = w1 << 5;
  assign w31 = w32 - w1;
  assign w124 = w31 << 2;
  assign w123 = w124 - w1;
  assign w31744 = w31 << 10;
  assign w31867 = w123 + w31744;
  assign o_data0 = w31867;

  //multiplier_block area estimate = 5624.94231249706;
endmodule