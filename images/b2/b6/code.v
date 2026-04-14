module top_module(flipin, flipout);input  [15:0] flipin;
  output [15:0] flipout;
  assign flipout[15] = flipin[0];
  assign flipout[14] = flipin[1];
  assign flipout[13] = flipin[2];
  assign flipout[12] = flipin[3];
  assign flipout[11] = flipin[4];
  assign flipout[10] = flipin[5];
  assign flipout[9] = flipin[6];
  assign flipout[8] = flipin[7];
  assign flipout[7] = flipin[8];
  assign flipout[6] = flipin[9];
  assign flipout[5] = flipin[10];
  assign flipout[4] = flipin[11];
  assign flipout[3] = flipin[12];
  assign flipout[2] = flipin[13];
  assign flipout[1] = flipin[14];
  assign flipout[0] = flipin[15];
endmodule