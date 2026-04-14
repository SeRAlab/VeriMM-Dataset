module top_module(
    X,
    A,
    B,
    C,
    D
);output X;
    input  A;
    input  B;
    input  C;
    input  D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Implement AND4 using only logic gates
    wire nand1;
    wire nand2;
    wire nand3;
    wire inv1;
    wire inv2;
    
    // Use continuous assignments instead of missing modules
    assign nand1 = ~(A & B);    // NAND gate implementation
    assign nand2 = ~(C & D);    // NAND gate implementation
    assign nand3 = ~(nand1 & nand2); // NAND gate implementation
    assign inv1 = ~nand3;        // Inverter implementation
    assign inv2 = ~inv1;         // Inverter implementation
    assign X = inv2;             // Output

endmodule