module top_module(
    A,
    B,
    S,
    Y
);input A, B, S;
    output Y;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire not_S;

    // Invert S to generate not_S
    assign not_S = ~S;

    // Multiplexing operation
    assign Y = (not_S & A) | (S & B);

endmodule