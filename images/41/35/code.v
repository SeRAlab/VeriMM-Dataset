module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire w1, w2, w3;

    // Using a 4-input NOR gate directly for simplicity
    assign Y = ~(A | B | C | D);

endmodule