module top_module(
    input a,
    input b,
    output out
);wire nand1_out, nand2_out, nand3_out;

    // First stage of pipeline
    assign nand1_out = ~(a & b);

    // Second stage of pipeline
    assign nand2_out = ~(nand1_out & nand1_out);

    // Third stage of pipeline
    assign nand3_out = ~(nand2_out & nand2_out);

    // Output of pipeline
    assign out = ~(nand3_out & nand3_out);

endmodule