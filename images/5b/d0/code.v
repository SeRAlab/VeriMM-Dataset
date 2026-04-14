module top_module(V, e);input [3:0] V;
  output e;

  assign e = V[3]&(V[2]|V[1]);endmodule