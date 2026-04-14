module top_module(
  input Cin,
  input [3:0] P, G,
  output [4:1] Carry
);assign Carry[1] = ( P[0] & Cin  ) | G[0];

  assign Carry[2] = ( P[1] & P[0] & Cin ) |
    ( P[1] & G[0] ) | G[1];

  assign Carry[3] = ( P[2] & P[1] & P[0] & Cin ) |
    ( P[2] & P[1] & G[0] ) |
    ( P[2] & G[1] ) | G[2];

  assign Carry[4] = ( P[3] & P[2] & P[1] & P[0] & Cin ) |
    ( P[3] & P[2] & P[1] & G[0] ) |
    ( P[3] & P[2] & G[1] ) |
    ( P[3] & G[2] ) | G[3];endmodule