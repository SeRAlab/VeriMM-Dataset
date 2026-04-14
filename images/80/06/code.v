module top_module(A, B, C, D, S, Z);input A, B, C, D;
input [1:0] S;
output Z;

wire Z1, Z2;

// Implement the logic for the MUX4X1 module
// using a combination of AND, OR, and NOT gates
wire S0_not, S1_not;
not (S0_not, S[0]);
not (S1_not, S[1]);
and (A_and, A, S0_not, S1_not);
and (B_and, B, S0_not, S[1]);
and (C_and, C, S[0], S1_not);
and (D_and, D, S[0], S[1]);
or (Z1, A_and, B_and);
or (Z2, C_and, D_and);
or (Z, Z1, Z2);

endmodule