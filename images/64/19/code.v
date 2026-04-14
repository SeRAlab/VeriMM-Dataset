module top_module(
    X   ,
    A1  ,
    A2  ,
    B1_N,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1  ;
    input  A2  ;
    input  B1_N;
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
    assign B = ~B1_N;
    assign C = ~VPWR;
    assign D = VGND;
    assign E = VPB & ~VNB;
    assign F = ~VPB & VNB;

    assign X = A & B & C & ~D & (E | F);

endmodule