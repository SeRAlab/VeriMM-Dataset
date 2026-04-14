module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    C1  ,
    D1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  C1  ;
    input  D1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire A;
    wire B;
    wire C;
    wire D;
    wire E;
    wire F;

    assign A = A1 & A2;
    assign B = ~A1 & ~A2;
    assign C = B1 & C1;
    assign D = ~B1 & ~C1;
    assign E = A & C;
    assign F = B & D;

    assign Y = E | F;

    // The following instance is commented out as the module can't be found
    // This should be replaced with an appropriate module or removed if not needed.
    // sky130_fd_sc_lp__o2111ai base (
    //     .Y(Y),
    //     .A1(A1),
    //     .A2(A2),
    //     .B1(B1),
    //     .C1(C1),
    //     .D1(D1),
    //     .VPWR(VPWR),
    //     .VGND(VGND),
    //     .VPB(VPB),
    //     .VNB(VNB)
    // );

endmodule