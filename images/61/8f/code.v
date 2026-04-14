module top_module(
    A,
    B,
    C,
    D,
    Y
);input A;
    input B;
    input C;
    input D;
    output Y;

    wire X;

    // You may need to include the actual gate behavior for sky130_fd_sc_ms__and4b_2
    // Here, I am providing a simple AND gate implementation instead
    assign X = ~(B & C & D); // Assuming you intended to use a 4-input AND with inversion on one input

    assign Y = A & X;

endmodule