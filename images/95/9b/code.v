module top_module(
    Y  ,
    A  ,
    B  ,
    C_N,
    D_N
);output Y  ;
    input  A  ;
    input  B  ;
    input  C_N;
    input  D_N;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    not (n1, A);
    not (n2, B);
    not (n3, C_N);
    not (n4, D_N);

    nand (n5, n1, n2);
    nand (n6, n3, n4);
    nand (Y, n5, n6);

endmodule