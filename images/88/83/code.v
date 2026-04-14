module top_module(
    Y,
    A,
    B,
    C,
    D
);output Y;
    input  A;
    input  B;
    input  C;
    input  D;

    wire nand_out;

    // Assuming sky130_fd_sc_hdll__nand3 is a valid module, please ensure it is included in the project.
    // If it's a hypothetical module and not defined, you can design a simple NAND gate below
    // or replace it with an existing module.

    // Example of a simple NAND gate implementation
    assign nand_out = ~(A & B & C);

    assign Y = (D == 1'b1) ? (~A & ~B & ~C) : nand_out;

endmodule