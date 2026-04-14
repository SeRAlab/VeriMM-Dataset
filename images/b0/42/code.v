module top_module(
    input a,
    input b,
    output out
);wire nand_out;

nand n1(a, b, nand_out);
nand n2(nand_out, nand_out, out);

endmodule