module top_module(
    A,
    B,
    C,
    D,
    X
);input A;
    input B;
    input C;
    input D;
    output X;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = (A & B & C & D) ? 0 : ((A | B | C | D) >= 2) ? 1 : (A | B | C | D);

endmodule