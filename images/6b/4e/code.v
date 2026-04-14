module top_module(V, z);input [4:0] V;
  output z;

  assign z = V[4] | ((V[3] & V[2]) | (V[3] & V[1]));
endmodule