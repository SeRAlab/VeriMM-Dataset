module top_module(
    input A,
    input B,
    input S,
    output Y
);wire nand0_out;
    wire nand1_out;
    wire nand2_out;
    wire nand3_out;

    nand nand0(nand0_out, A, S);
    nand nand1(nand1_out, B, S);
    nand nand2(nand2_out, nand0_out, nand0_out);
    nand nand3(Y, nand1_out, nand1_out, nand2_out);

endmodule