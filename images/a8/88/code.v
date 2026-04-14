module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1_N
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1_N;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign Y = (B1_N == 1'b1) ? 1'b0 : ((A1 == 1'b1) ? 1'b1 : ((A2 == 1'b1) ? 1'b0 : 1'b1));

endmodule