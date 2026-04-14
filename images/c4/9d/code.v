module my_module (
    input A1_N,
    input A2_N,
    input B1,
    input B2,
    output X
);

    wire nand_out;
    wire or_out;
    wire and_out;

    nand nand_gate (
        .a(A1_N),
        .b(A2_N),
        .o(nand_out)
    );

    or or_gate (
        .a(B1),
        .b(B2),
        .o(or_out)
    );

    and and_gate (
        .a(nand_out),
        .b(or_out),
        .o(and_out)
    );

    assign X = and_out;

endmodule