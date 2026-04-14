module top_module(
    Y,
    A
);output Y;
    input  A;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign Y = A; // Buffer implementation
    // assign Y = ~A; // Inverter implementation

endmodule