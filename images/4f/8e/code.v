module top_module(
  input [7:0] posit,
  output [6:0] shift_onehot);wire [5:0] xnorlines;
  wire [5:0] xorlines;

  assign xorlines = (posit[5:0] ^ {6{posit[6]}});
  assign xnorlines = ~(xorlines);
  assign shift_onehot[0] = xorlines[5];
  assign shift_onehot[1] = &({xorlines[4],xnorlines[5]});
  assign shift_onehot[2] = &({xorlines[3],xnorlines[5:4]});
  assign shift_onehot[3] = &({xorlines[2],xnorlines[5:3]});
  assign shift_onehot[4] = &({xorlines[1],xnorlines[5:2]});
  assign shift_onehot[5] = &({xorlines[0],xnorlines[5:1]});
  assign shift_onehot[6] = &(xnorlines[5:0]);endmodule