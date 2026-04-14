module top_module(
    input CLK,
    input D,
    input RESET_B,
    output Q,
    output Q_N
);wire D_N;
    wire Q_next;
    wire Q_N_next;

    // Invert the D input
    assign D_N = ~D;

    // Implement the reset functionality
    assign Q = RESET_B ? 1'b0 : Q_next;
    assign Q_N = RESET_B ? 1'b1 : Q_N_next;

    // Implement the D flip-flop
    nand gate1 (Q_next, CLK, D_N, Q_N_next);
    nand gate2 (Q_N_next, CLK, D, Q_next);

endmodule