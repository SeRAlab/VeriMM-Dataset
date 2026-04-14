module top_module(
    input D,
    output Q
);wire nand1_out;
    wire nand2_out;

    nand nand1 (nand1_out, D, Q);
    nand nand2 (nand2_out, nand1_out, Q);
    not  not_gate (Q, nand2_out);

endmodule