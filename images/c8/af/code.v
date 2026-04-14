module RAT_slice_1_0_0
   (Din,
    Dout);
  input [17:0] Din;
  output [7:0] Dout;

  assign Dout[7:0] = Din[7:0];
endmodule