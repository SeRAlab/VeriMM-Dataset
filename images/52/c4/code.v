module top_module(
    input a,
    input b,
    output out
);wire nand1_out, nand2_out;

nand nand1(a, a, nand1_out);
nand nand2(b, b, nand2_out);
nand nand3(nand1_out, nand2_out, out);

endmodule