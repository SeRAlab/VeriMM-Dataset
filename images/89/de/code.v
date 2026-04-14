module top_module(
    Z,
    A,
    B,
    C,
    D,
    TE
);output Z;
    input A, B, C, D, TE;

    wire nand1_out, nand2_out, nand3_out;

    // Behavioral NAND gate implementations
    assign nand1_out = ~(A & B & TE);
    assign nand2_out = ~(C & D & TE);
    assign nand3_out = ~(nand1_out & nand2_out & TE);

    assign Z = nand3_out; // Output Z is the result of the final NAND

endmodule