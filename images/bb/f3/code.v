module top_module(
  input [1:0] inv_rails,
  input [6:0] shift_onehot,
  output [13:1] regime_onehot);assign regime_onehot[6:1] = ({6{inv_rails[0]}} & {shift_onehot[0], shift_onehot[1], shift_onehot[2], shift_onehot[3], shift_onehot[4], shift_onehot[5]});
  assign regime_onehot[13:7] = ({7{inv_rails[1]}} & shift_onehot[6:0]);endmodule