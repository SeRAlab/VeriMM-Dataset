module top_module(
    input a,
    input b,
    output y
);wire not_a, not_b, nand_out;

    not not_a_inst (not_a, a);
    not not_b_inst (not_b, b);
    nand nand_inst (nand_out, not_a, not_b);
    not not_y_inst (y, nand_out);

endmodule