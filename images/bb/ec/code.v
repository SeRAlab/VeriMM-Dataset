module top_module(
    input A,
    input B,
    output Y
);wire not_A;
    wire not_B;
    wire or_out;
    wire nand_out;

    not not_A_inst (not_A, A);
    not not_B_inst (not_B, B);
    or or_inst (or_out, not_A, not_B);
    nand nand_inst (nand_out, or_out, or_out);
    buf buf_inst (Y, nand_out);

endmodule