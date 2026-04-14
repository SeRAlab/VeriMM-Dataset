module top_module(
    X    ,
    A    ,
    SLEEP
);output X    ;
    input  A    ;
    input  SLEEP;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = !SLEEP ? A : 1'b0;

endmodule