module not_gate(
    input in,
    output out
);

    wire nand_out;

    // Implementing NOT gate using two NAND gates
    nand n1(in, in, nand_out);
    nand n2(nand_out, nand_out, out);

endmodule