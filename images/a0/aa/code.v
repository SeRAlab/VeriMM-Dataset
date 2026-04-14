module top_module(
    input  A_N,
    input  B_N,
    input  C  ,
    input  D  ,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = ~(A_N | B_N | ~C | ~D);

endmodule