module top_module(
    input [15:0] A, B,
    input Cin,
    output [15:0] S,
    output Cout
);wire [7:0] G, P;
wire [7:0] C1, C2, C3;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen
        assign G[i] = A[i] & B[i];
        assign P[i] = A[i] ^ B[i];
        assign C1[i] = (i == 0) ? Cin : (G[i-1] | (P[i-1] & C1[i-1]));
        assign C2[i] = G[i] | (P[i] & C1[i]);
        assign C3[i] = (P[i] & G[i-1]) | (P[i] & P[i-1] & C1[i-1]);
    end
endgenerate

assign S = A + B + Cin;
assign Cout = (C3[7] == 1) ? C2[7] : C1[7];

endmodule