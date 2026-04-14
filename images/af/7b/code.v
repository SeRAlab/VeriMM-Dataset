module top_module(
    output X,
    input A,
    input B,
    input C,
    input D
);wire X1;
    wire X2;

    // Replace with standard 4-input AND logic
    assign X1 = A & B; // AND gate for A and B
    assign X2 = C & D; // AND gate for C and D
    assign X = X1 & X2; // Final AND gate between X1 and X2

endmodule