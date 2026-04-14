module top_module(
    A,
    B,
    C,
    D,
    Y,
    VDD,
    GND
    );input A, B, C, D;
    output Y;
    input VDD, GND;

    wire nand1_out, nand2_out, nand3_out;

    // Implementing a simple NAND gate using assign statement for demonstration purposes
    assign nand1_out = ~(A & B);
    assign nand2_out = ~(C & D);
    assign nand3_out = ~(nand1_out & nand2_out);
    assign Y = ~(nand3_out & nand3_out); // This is equivalent to nand(nand3_out, nand3_out)

endmodule