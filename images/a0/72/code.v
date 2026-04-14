module top_module(
    A,
    B,
    C,
    D,
    E,
    Y
);input A;
    input B;
    input C;
    input D;
    input E;
    output Y;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign Y = (A & B) | (!C & D & !E);

endmodule