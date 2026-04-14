module top_module(
    input [3:0] A,
    input [1:0] S,
    output X,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);wire s0, s1, not_s0, not_s1;

assign s0 = S[0];
assign s1 = S[1];
assign not_s0 = ~S[0];
assign not_s1 = ~S[1];

wire x0, x1, x2, x3;

// Replace the unknown module references with gate definitions
assign x0 = A[0] & not_s0 & not_s1; // A[0] when S = 00
assign x1 = A[1] & s0 & not_s1;     // A[1] when S = 01
assign x2 = A[2] & not_s0 & s1;     // A[2] when S = 10
assign x3 = A[3] & s0 & s1;         // A[3] when S = 11

// Use an OR gate to combine the results
assign X = x0 | x1 | x2 | x3;

endmodule