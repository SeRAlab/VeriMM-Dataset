module top_module(
    Y ,
    A1,
    A2,
    B1
);// Module ports
    output Y ;
    input  A1;
    input  A2;
    input  B1;

    // Local signals
    wire or_out    ;
    wire nand_out_Y;

    //   Name   Output       Other arguments
    or   or0   (or_out    , A2, A1         );
    nand nand0 (nand_out_Y, or_out, B1    );
    buf  buf0  (Y          , nand_out_Y    );

endmodule