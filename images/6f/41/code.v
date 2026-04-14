module top_module(
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire A1_AND_A2;
    wire A3_AND_B1;

    assign A1_AND_A2 = A1 & A2;
    assign A3_AND_B1 = A3 & B1;

    assign X = (A1_AND_A2 | A3_AND_B1) ? 1'b1 : 1'b0;

endmodule