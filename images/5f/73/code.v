module top_module(
    Y,
    A,
    B
);output Y;
    input A, B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Inverter logic
    assign Y = (A & ~B) | (~A & B);

endmodule