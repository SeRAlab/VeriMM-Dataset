module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1_N
);// Module ports
    output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1_N;

    // Local signals
    wire b          ;
    wire or0_out    ;
    wire nand0_out_Y;
    wire nand1_out  ;

    //   Name   Output       Other arguments
    not  not0  (b          , B1_N           );
    or   or0   (or0_out    , A2, A1         );
    nand nand0 (nand0_out_Y, b, or0_out     );
    nand nand1 (nand1_out  , nand0_out_Y, nand0_out_Y);
    buf  buf0  (Y          , nand1_out      );

endmodule