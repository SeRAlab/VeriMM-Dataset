module top_module(
    Y,
    A,
    B
);// Module ports
    output Y;
    input  A;
    input  B;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire not0_out_A, not0_out_B, and0_out, and1_out, or0_out;

    //  Name  Output         Other arguments
    not not0_A (not0_out_A, A                 );
    not not0_B (not0_out_B, B                 );
    and and0   (and0_out  , not0_out_A, B     );
    and and1   (and1_out  , A        , not0_out_B);
    or  or0    (or0_out   , and0_out , and1_out );

    assign Y = or0_out;

endmodule