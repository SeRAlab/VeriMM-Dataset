module top_module(
    input A,
    input B,
    output Y
);wire not_A, not_B, or_AB;

    // Invert A and B
    not #(1) not_A_inst (not_A, A);
    not #(1) not_B_inst (not_B, B);

    // OR the inverted A and B
    or #(1) or_AB_inst (or_AB, not_A, not_B);

    // Invert the output of the OR gate to get the AND output
    not #(1) not_Y_inst (Y, or_AB);

endmodule