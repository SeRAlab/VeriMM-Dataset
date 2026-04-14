module top_module(
    Y  ,
    A  ,
    B_N
);output Y  ;
    input  A  ;
    input  B_N;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign Y = ~(A | B_N);

endmodule