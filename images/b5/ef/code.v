module top_module(
    input A,
    input B,
    input VPWR,
    input VGND,
    output Y
);wire A1, A2;

    // Connect the AND gate inputs to the appropriate signals
    assign A1 = A;
    assign A2 = B;

    // Instantiate the AND gate directly
    assign Y = A1 & A2;

endmodule