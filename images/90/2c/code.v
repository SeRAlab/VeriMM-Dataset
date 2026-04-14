module top_module(
    i_data0,
    o_data0
);// Port mode declarations:
  input   [3:0] i_data0;
  output  [15:0] o_data0;

  //Multipliers:

  wire [15:0]
    w1,
    w256,
    w257,
    w8224,
    w8225,
    w16,
    w241,
    w964,
    w7261;

  assign w1 = {i_data0, 4'b0};
  assign w16 = w1 << 4;
  assign w257 = w1 + (w1 << 8);
  assign w241 = w257 - w16;
  assign w8224 = w257 << 5;
  assign w8225 = w1 + w8224;
  assign w964 = w241 << 2;
  assign w7261 = w8225 - w964;
  assign o_data0 = w7261;

  //multiplier_block area estimate = 7338.03834891177;
endmodule