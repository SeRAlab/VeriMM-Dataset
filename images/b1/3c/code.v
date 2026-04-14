module top_module(
    input a,
    input b,
    output out
);wire nand1_out, nand2_out, and_out;

nand nand1(a, b, nand1_out);
nand nand2(a, b, nand2_out);
and and_gate(nand1_out, nand2_out, and_out);
nand inv(and_out, and_out, out);

endmodule