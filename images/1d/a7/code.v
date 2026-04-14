module hazard_detection(
    input wire A,
    input wire B,
    output wire C
);
    wire A_n, B_n;
    wire temp1, temp2;

    // Inverting A and B for hazard detection
    not(A_n, A);
    not(B_n, B);

    // Main logic with hazard detection
    assign temp1 = A & B; // Main output
    assign temp2 = A_n & B_n; // Detection logic
    assign C = (temp1 | temp2); // Final output, ensuring stability
endmodule