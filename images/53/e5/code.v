module top_module(
    input A,
    input B,
    output X
);wire and_AB;

    // AND gate directly from inputs
    assign and_AB = A & B;

    // Assign the output directly from the AND operation
    assign X = and_AB;

endmodule