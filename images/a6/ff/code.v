module top_module(
    input  A,
    input  B,
    output Y
);assign Y = ~(A & B);  // Directly assigning the NAND functionality

endmodule