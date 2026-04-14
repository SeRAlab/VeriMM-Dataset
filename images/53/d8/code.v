module top_module(
    input [3:0] A,
    output Y
);wire nand0_out, nand1_out, nand2_out, nand3_out;

    // Using standard gates instead of specific library gates
    assign nand0_out = ~(A[0] & A[1]);
    assign nand1_out = ~(A[2] & A[3]);
    assign nand2_out = ~(nand0_out & nand1_out);
    assign nand3_out = ~(nand2_out & nand2_out); // This is equivalent to an inverter
    assign Y = ~nand3_out; // Inverting the output

endmodule