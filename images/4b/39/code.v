module top_module(
    X   ,
    A1  ,
    A2  ,
    VPWR,
    VGND
);output X   ;
    input  A1  ;
    input  A2  ;
    input  VPWR;
    input  VGND;

    wire A1_AND_A2;
    assign A1_AND_A2 = A1 & A2;

    wire VPWR_GT_VGND;
    assign VPWR_GT_VGND = VPWR > VGND;

    assign X = A1_AND_A2 & VPWR_GT_VGND;

endmodule