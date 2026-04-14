module top_module(S, D0, D1, D2, D3, Z);input  [1:0] S; // S should be a 2-bit input
input  D0;
input  D1;
input  D2;
input  D3;
output Z;

wire not_S1, not_S0;
wire M0, M1, M2, M3;
wire O0, O1;

not (not_S1, S[1]);
not (not_S0, S[0]);

and (M0, D0, not_S1, not_S0);
and (M1, D1, not_S1, S[0]); // Corrected S0 to S[0]
and (M2, D2, S[1], not_S0); // Corrected S1 to S[1]
and (M3, D3, S[1], S[0]);   // Corrected S1 and S0 to S[1] and S[0]

or (O0, M0, M1);
or (O1, M2, M3);

or (Z, O0, O1); // Corrected to use a single OR to combine O0 and O1

endmodule