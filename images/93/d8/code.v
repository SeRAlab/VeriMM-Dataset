module top_module(
  input  [3:0] D,
  input  [1:0] S,
  output Y
);assign Y = (S[1] & S[0]) ? D[3] :
            (S[1] & ~S[0]) ? D[2] :
            (~S[1] & S[0]) ? D[1] :
            (~S[1] & ~S[0]) ? D[0] :
            1'bz;

endmodule