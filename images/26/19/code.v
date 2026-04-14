module hazard_detection_resolution (
    input wire A,
    input wire B,
    input wire C,
    output wire F
);
    wire w1, w2, w3, w4, w5;

    // Generate the sum of products
    assign w1 = A & B & ~C;  // minterm 3: 011
    assign w2 = A & ~B & C;  // minterm 5: 101
    assign w3 = ~A & B & C;  // minterm 6: 110
    assign w4 = A & B & C;   // minterm 7: 111
    assign w5 = ~A & B & ~C; // minterm 2: 010

    // Final output with hazard resolution
    assign F = w1 | w2 | w3 | w4 | w5;

endmodule