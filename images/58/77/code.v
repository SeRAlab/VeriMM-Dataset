module top_module(
    input a,
    input b,
    input sel,
    output out
);wire nand1_out, nand2_out;

nand nand1(nand1_out, a, sel);
nand nand2(nand2_out, b, sel);

not not_gate(sel, sel_bar);
nand nand3(out, nand1_out, nand2_out);

endmodule