module top_module(
  input [9:0] id0_m,
  input [9:0] id1_m,
  input [9:0] id2_m,
  input [9:0] id3_m,
  output [3:0] mask_id
);assign mask_id[0] = ^id0_m;
  assign mask_id[1] = ^id1_m;
  assign mask_id[2] = ^id2_m;
  assign mask_id[3] = ^id3_m;

endmodule