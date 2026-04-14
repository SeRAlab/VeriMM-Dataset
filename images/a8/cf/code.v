module top_module(
  input [3:0] A,
  input [3:0] B,
  input SUB,
  output [3:0] SUM,
  output CARRY
);wire [3:0] P, G;
  wire [4:0] C;

  assign P = A ^ B;
  assign G = A & B;
  assign C[0] = SUB;

  // Brent-Kung adder
  genvar i;
  generate
    for (i = 1; i < 4; i = i + 1) begin : brent_kung
      assign C[i] = (G[i-1] & P[i]) | (C[i-1] & (G[i-1] | P[i]));
      assign G[i] = G[i-1] & G[i] & (~P[i-1] | ~C[i-1]) | P[i-1] & ~G[i] & (C[i-1] | G[i-1]);
      assign P[i] = P[i-1] & P[i] & (~G[i-1] | ~C[i-1]) | ~P[i-1] & (G[i-1] ^ C[i-1]) & (~G[i] | ~C[i-1]);
    end
  endgenerate

  assign SUM = P ^ C[3];
  assign CARRY = C[4];

endmodule