module top_module(
    input [1:0] A,
    input [1:0] B,
    output EQ
);wire eq1, eq2, eq3, eq4;

    // Compare the most significant bits of A and B
    wire and1, and2; // wires to hold intermediate results
    and(and1, A[1], B[1]);
    and(and2, ~A[1], ~B[1]);

    // Compare the least significant bits of A and B
    wire and3, and4; // wires to hold intermediate results
    and(and3, A[0], B[0]);
    and(and4, ~A[0], ~B[0]);

    // Combine the results of the two comparisons
    wire eq_msb, eq_lsb; // wires for outputs of each bit comparison
    or(eq_msb, and1, and2);
    or(eq_lsb, and3, and4);
    
    and(EQ, eq_msb, eq_lsb); // Final EQ output

endmodule