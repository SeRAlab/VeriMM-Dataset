module nor2b (
    Y  ,
    A  ,
    B_N
);

    // Module ports
    output Y  ;
    input  A  ;
    input  B_N;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire not0_out  ;
    wire and0_out_Y;

    //  Name  Output      Other arguments
    not not0 (not0_out  , A              );
    and and0 (and0_out_Y, not0_out, B_N  );
    buf buf0 (Y         , and0_out_Y     );

endmodule