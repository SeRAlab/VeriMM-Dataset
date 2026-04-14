module top_module(
    output Y,
    input  A,
    input  B,
    input  C,
    input  D   
);wire nand1_out;
    
    // Implementing the 4-input NAND using a continuous assignment statement
    assign nand1_out = ~(A & B & C & D); // Output of NAND gate

    // As Y should be the NAND of the inputs, we can directly assign
    assign Y = nand1_out;

endmodule