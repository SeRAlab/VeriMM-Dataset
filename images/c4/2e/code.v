module logic_gate (
    input A1,
    input A2,
    input B1,
    output Y
);

    // Local signals
    wire or_out;
    wire nand_out;

    // OR gate
    or or_gate (
        .A(A1),
        .B(A2),
        .Y(or_out)
    );

    // NAND gate
    nand nand_gate (
        .A(B1),
        .B(or_out),
        .Y(nand_out)
    );

    // Output buffer
    buf buf_gate (
        .A(nand_out),
        .Y(Y)
    );

endmodule