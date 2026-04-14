module top_module(
    X ,
    A1,
    A2,
    B1,
    B2,
    C1,
    C2
);output X ;
    input  A1;
    input  A2;
    input  B1;
    input  B2;
    input  C1;
    input  C2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Output logic
    assign X = (A1 & A2 & ~B1 & ~B2 & C1 & C2) | (~A1 & ~A2 & B1 & B2 & C1 & C2) | (~A1 & ~A2 & ~B1 & ~B2 & ~C1 & ~C2) | (A1 & A2 & B1 & B2 & ~C1 & ~C2);

endmodule