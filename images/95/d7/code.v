module top_module(
    Y  ,
    A  ,
    B  ,
    C  ,
    D
);output Y  ;
    input  A  ;
    input  B  ;
    input  C  ;
    input  D  ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Perform NAND operation
    wire nand1, nand2, nand3, nand4;
    assign nand1 = ~(A & B);
    assign nand2 = ~(nand1 & C);
    assign nand3 = ~(nand2 & D);
    assign nand4 = ~nand3;
    assign Y = nand4;

endmodule