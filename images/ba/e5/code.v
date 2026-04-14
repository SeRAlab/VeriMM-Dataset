module top_module(
    Y ,
    A1,
    A2,
    A3,
    B1,
    C1
);// Module ports
    output Y ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;
    input  C1;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire and0_out;
    wire or0_out;
    wire nand0_out_Y;

    //   Name   Output       Other arguments
    and  and0  (and0_out   , A1, A2, A3    );
    or   or0   (or0_out    , B1, C1        );
    nand nand0 (nand0_out_Y, and0_out, or0_out);
    buf  buf0  (Y          , nand0_out_Y    );

endmodule