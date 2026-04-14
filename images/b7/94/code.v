module top_module(
    X    ,
    SLEEP,
    A
);// Module ports
    output X    ;
    input  SLEEP;
    input  A    ;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire not0_out  ;
    wire and0_out_X;

    //  Name  Output      Other arguments
    not not0 (not0_out  , SLEEP          );
    and and0 (and0_out_X, not0_out, A    );
    buf buf0 (X         , and0_out_X     );

endmodule