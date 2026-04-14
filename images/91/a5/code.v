module top_module(
    Y ,
    A1,
    A2,
    A3,
    B1
);// Module ports
    output Y ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;

    // Local signals
    wire or0_out    ;
    wire nand0_out_Y;

    //   Name   Output       Other arguments
    or   or0   (or0_out    , A2, A1, A3     );
    nand nand0 (nand0_out_Y, B1, or0_out    );
    buf  buf0  (Y          , nand0_out_Y    );

endmodule