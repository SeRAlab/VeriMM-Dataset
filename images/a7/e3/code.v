module top_module(
    A,
    B,
    X
);input A, B;
    output X;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // Using a behavioral description for XOR logic
    assign X = A ^ B;

endmodule