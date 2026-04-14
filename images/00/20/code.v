module ripple_carry_adder(
    input  [3:0] A,
    input  [3:0] B,
    input  Cin,
    output [3:0] S,
    output Cout
);

wire [3:0] G, P;
wire C1, C2, C3;

assign G = A & B;  // Generate
assign P = A ^ B;  // Propagate

assign C1 = G[0] | (P[0] & Cin);
assign S[0] = P[0] ^ Cin;

assign C2 = G[1] | (P[1] & C1);
assign S[1] = P[1] ^ C1;

assign C3 = G[2] | (P[2] & C2);
assign S[2] = P[2] ^ C2;

assign Cout = G[3] | (P[3] & C3);
assign S[3] = P[3] ^ C3;

endmodule