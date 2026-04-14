module mux_2to1 (
    input A,
    input B,
    input SEL,
    output Y
);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Output assignment
    assign Y = SEL ? B : A;

endmodule