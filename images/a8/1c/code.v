module top_module(
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    VPWR,
    VGND
);// Module ports
    output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  VPWR;
    input  VGND;

    // Local signals
    wire	B1_and0_out          ;
    wire    nor0_out_Y        ;

    //                           Name          Output              Other arguments
    and                          and0         (B1_and0_out          , A3, A1, A2            );
    nor                          nor0         (nor0_out_Y        , B1, B1_and0_out          );
    // Removed the instantiation of unknown module
    buf                          buf0         (Y                 , nor0_out_Y            );

endmodule