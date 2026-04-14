module nand_gate (
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);
    assign Y = ~(A & B & C); // NAND gate implementation
endmodule