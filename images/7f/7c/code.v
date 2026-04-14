module top_module(
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    A4  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  A4  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // 2-input NAND gate
    wire n1;
    assign n1 = ~(A1 & A2);

    // 4-input AND gate
    wire n2;
    assign n2 = ~(A3 & A4 & B1 & n1);

    // Output
    assign Y = n2;

endmodule