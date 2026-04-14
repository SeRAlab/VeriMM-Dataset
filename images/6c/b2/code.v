module top_module(
    X  ,
    A_N,
    B  ,
    C  ,
    D
);output X  ;
    input  A_N;
    input  B  ;
    input  C  ;
    input  D  ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = ~(A_N | B | C | D);

endmodule