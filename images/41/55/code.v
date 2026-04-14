module top_module(
    input  A  ,
    input  B  ,
    input  C  ,
    input  D_N,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire temp;

    assign temp = A | B | C | D_N;
    assign X = ~temp;

endmodule