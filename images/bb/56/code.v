module top_module(
    input   [31:0] i_data0,
    output  [31:0] o_data0
);//Multipliers:

  wire [31:0]
    w1,
    w4,
    w5,
    w10,
    w2048,
    w2047,
    w640,
    w2687,
    w2677;

  assign w1 = i_data0;
  assign w4 = i_data0 << 2;
  assign w5 = i_data0 + w4;
  assign w10 = w5 << 1;
  assign w2048 = i_data0 << 11;
  assign w2047 = w2048 - w1;
  assign w640 = w5 << 7;
  assign w2687 = w2047 + w640;
  assign w2677 = w2687 - w10;

  assign o_data0 = w2677;

  //multiplier_block area estimate = 7171.71836743236;
endmodule