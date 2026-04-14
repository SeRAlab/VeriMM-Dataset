module top_module(S, z);input [4:0] S;
  output z;

  assign z = S[4]|(S[3]&(S[2]|S[1]));endmodule