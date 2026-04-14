module top_module(
    input A,
    input B,
    input SEL,
    output Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire nand1_out, nand2_out;

    // Using basic gates instead of missing library cells
    wire sel_not = ~SEL;  // Inverted SEL signal

    // NAND logic for the mux implementation
    assign nand1_out = ~(A & sel_not); // Implementing NAND with A and not SEL
    assign nand2_out = ~(B & SEL);     // Implementing NAND with B and SEL

    // Final output using NAND outputs
    assign Y = ~(nand1_out & nand2_out); // Final output to select between A and B

endmodule