module top_module(
    X   ,
    A   ,
    B   ,
    C   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);// Module ports
    output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Local signals
    wire and0_out_X       ;
    wire pwrgood_pp0_out_X;

    // AND gate implementation
    assign and0_out_X = A & B & C;

    // Power good implementation
    assign pwrgood_pp0_out_X = (and0_out_X == VPWR) && (VGND == 0);

    // Buffer implementation
    assign X = pwrgood_pp0_out_X;

endmodule