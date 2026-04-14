module top_module(
    input A,
    input B,
    input C,
    output Y
);// Define internal signals
    wire nand1_out;
    wire nand2_out;

    // Implement NAND3 gate with minimum number of gates
    assign nand1_out = ~(A & B); // NAND gate for inputs A and B
    assign nand2_out = ~(nand1_out & C); // NAND gate for nand1_out and C
    assign Y = ~nand2_out; // NOT the output of nand2 to get Y (the final output)

endmodule