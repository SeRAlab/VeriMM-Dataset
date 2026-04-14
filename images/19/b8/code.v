module xor_using_nand (
    input wire A,
    input wire B,
    output wire Y
);
    
    wire nand1, nand2, nand3;
    
    // Implementing XOR using NAND gates
    assign nand1 = ~(A & B);     // NAND of A and B
    assign nand2 = ~(A & nand1); // NAND of A and (A NAND B)
    assign nand3 = ~(B & nand1); // NAND of B and (A NAND B)
    assign Y = ~(nand2 & nand3); // Final output Y = (A NAND (A NAND B)) NAND (B NAND (A NAND B))

endmodule