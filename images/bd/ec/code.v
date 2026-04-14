module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);// Define a wire to store the AND of A and B
    wire AB = A & B;

    // Define a wire to store the AND of C and D
    wire CD = C & D;

    // Define a wire to store the AND of AB and CD
    wire ABCD = AB & CD;

    // Assign the output Y to the value of ABCD
    assign Y = ABCD;

endmodule