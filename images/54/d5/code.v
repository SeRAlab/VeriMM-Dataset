module top_module(
    input  A  ,
    input  B_N,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = ~(A & B_N);

endmodule