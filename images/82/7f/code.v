module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);wire X1;

    // Assuming we want to use a AND gate instead of the unknown module
    assign X1 = A & B & C & D; // Creating a 4-input AND logic using primitive gates

    assign X = X1; // Assign the output directly to X

endmodule