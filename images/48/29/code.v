module top_module(Cin, P, G, C);input Cin;
input [15:0] P;
input [15:0] G;
output [3:0] C;

reg P0, P1, P2, P3;
reg G0, G1, G2, G3;

always @(*) begin
 P0<= &P[3:0];
 P1<= &P[7:4];
 P2<= &P[11:8];
 P3<= &P[15:12];

 G0<=G[3] | P[3]&G[2] | P[3]&P[2]&G[1] | P[3]&P[2]&P[1]&G[0];
 G1<=G[7] | P[7]&G[6] | P[7]&P[6]&G[5] | P[7]&P[6]&P[5]&G[4];
 G2<=G[11] | P[11]&G[10] | P[11]&P[10]&G[9] | P[11]&P[10]&P[9]&G[8];
 G3<=G[15] | P[15]&G[14] | P[15]&P[14]&G[13] | P[15]&P[14]&P[13]&G[12];
end


  assign C[0] = G0 + (P0&Cin); 
  assign C[1] = G1 + (P1&G0) + (P1&P0&Cin); 
  assign C[2] = G2 + (P2&G1) + (P2&P1&G0) + (P2&P1&P0&Cin); 
  assign C[3] = G3 + (P3&G2) + (P3&P2&G1) + (P3&P2&P1&G0) + (P3&P2&P1&P0&Cin);endmodule