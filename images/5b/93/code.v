module top_module(
    X ,
    A0,
    A1,
    S
);output X ;
    input  A0;
    input  A1;
    input  S ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Implementation of 2:1 multiplexer
    assign X = (S == 0) ? A0 : A1;

endmodule