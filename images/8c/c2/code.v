module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    output EQ,
    output GT
);wire eq1, eq2, eq3, gt1, gt2, gt3, gt4, gt5;

// Check if A=B
assign eq1 = (A == B);

// Check if B=C
assign eq2 = (B == C);

// Check if C=D
assign eq3 = (C == D);

// Check if A>B
assign gt1 = (A > B);

// Check if B>C
assign gt2 = (B > C);

// Check if C>D
assign gt3 = (C > D);

// Check if A>B>C>D
assign gt4 = (gt1 && gt2 && gt3);

// Check if A=B=C=D
assign gt5 = (eq1 && eq2 && eq3);

// Output EQ
assign EQ = (eq1 && eq2 && eq3);

// Output GT
assign GT = (gt4 || gt5);

endmodule