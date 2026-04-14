module top_module(
    Y ,
    A1,
    A2,
    B1,
    C1
);// Module ports
    output Y ;
    input  A1;
    input  A2;
    input  B1;
    input  C1;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire or0_out   ;
    wire and0_out  ;
    wire not0_out  ;

    //  Name  Output       Other arguments
    or  or0  (or0_out   , A1, A2         );
    and and0 (and0_out  , or0_out, B1, C1);
    not not0 (not0_out  , and0_out       );
    buf buf0 (Y         , not0_out       );

endmodule