module top_module(
    Y,
    A,
    B,
    C,
    D
);output Y;
    input A;
    input B;
    input C;
    input D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire nand1;
    wire nand2;
    wire nand3;

    // Using primitive NAND gates as placeholders
    assign nand1 = ~(A & B & C & D);
    assign nand2 = ~(nand1 & nand1 & nand1 & nand1); // This effectively creates a 4-input NAND
    assign nand3 = ~(nand2 & nand2 & nand2 & nand2); // Chain of 4-input NANDs to replicate functionality

    assign Y = ~(nand3 & nand3 & nand3 & nand3); // Final output

endmodule