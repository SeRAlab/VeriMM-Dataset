module top_module(
  input [7:0] posit,
  input [6:0] shift_onehot,
  output [4:0] expfrac);assign expfrac[0] = (shift_onehot[0] & posit[0]);
  assign expfrac[1] = |(({shift_onehot[0], shift_onehot[1]} & posit[1:0]));
  assign expfrac[2] = |(({shift_onehot[0], shift_onehot[1], shift_onehot[2]} & posit[2:0]));
  assign expfrac[3] = |(({shift_onehot[0], shift_onehot[1], shift_onehot[2], shift_onehot[3]} & posit[3:0]));
  assign expfrac[4] = |(({shift_onehot[0], shift_onehot[1], shift_onehot[2], shift_onehot[3], shift_onehot[4]} & posit[4:0]));endmodule