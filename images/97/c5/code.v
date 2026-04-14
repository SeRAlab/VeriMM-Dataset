module top_module(
    A,
    B,
    Y
);output Y;
    input A;
    input B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // AND gate implementation
    assign Y = A & B;

endmodule