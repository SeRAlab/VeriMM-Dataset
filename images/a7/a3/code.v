module top_module(
  input [7:0] in1,
  input [7:0] in2,
  output out
);wire [7:0] diff;
  assign diff = in1 - in2;

  assign out = (diff[7] == 1) ? 1 : ((diff[6] == 1) ? 1 :
               ((diff[5] == 1) ? 1 : ((diff[4] == 1) ? 1 :
               ((diff[3] == 1) ? 1 : ((diff[2] == 1) ? 1 :
               ((diff[1] == 1) ? 1 : ((diff[0] == 1) ? 1 : 0)))))));

endmodule