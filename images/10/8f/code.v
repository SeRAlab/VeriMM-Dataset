module hazard_detection(
    input wire A,
    input wire B,
    input wire C,
    output wire F
);
    wire A_not, B_not, C_not;
    wire term1, term2, term3, term4;

    // Inversions
    not (A_not, A);
    not (B_not, B);
    not (C_not, C);

    // Product terms
    and (term1, A_not, B_not, C); // A'B'C
    and (term2, A, B_not, C);     // AB'C
    and (term3, A, B, C_not);     // ABC'
    and (term4, A, B, C);         // ABC

    // Final output
    or (F, term1, term2, term3, term4);
endmodule