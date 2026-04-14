module top_module(
    Y,
    A,
    B,
    C
);output Y;
    input  A;
    input  B;
    input  C;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign Y = ~(A & B & C);

endmodule