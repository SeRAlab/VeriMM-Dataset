module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Instantiate the intended standard cell module after checking if it's available
    `ifdef USE_STD_CELL
        sky130_fd_sc_ms__a21oi base (
            .Y(Y),
            .A1(A1),
            .A2(A2),
            .B1(B1),
            .VPWR(VPWR),
            .VGND(VGND),
            .VPB(VPB),
            .VNB(VNB)
        );
    `else
        // Provide an alternative implementation or a simple combinatorial logic
        assign Y = (A1 & A2) | (~B1);
    `endif

endmodule