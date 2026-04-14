module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);wire Y1, Y2, Y3;

    // Using primitive gates instead, since sky130_fd_sc_hd__or4bb_2 is unknown.
    assign Y1 = A | B;
    assign Y2 = C | D;
    assign Y3 = Y1 | Y2;

    assign X = Y3;

endmodule