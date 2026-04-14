module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire AB, CD;

    // Use built-in NAND gate functionality directly if sky130_fd_sc_hd__nand2 is not available
    assign AB = ~(A & B);
    assign CD = ~(C & D);
    assign Y = ~(AB & CD);

endmodule