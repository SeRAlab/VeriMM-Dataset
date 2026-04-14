module top_module(
    A1, A2, B1, B2, 
    VPWR, VGND, VPB, VNB
);// Module ports
    input  A1, A2, B1, B2;
    input  VPWR, VGND;
    output VPB, VNB;

    // Local signals
    wire pgood_out;

    //                                 Name         Output             Other arguments
    or                                 or0         (pgood_out        , A2, A1                );
    or                                 or1         (pgood_out        , B2, B1                );
    buf                                buf0        (VPB              , pgood_out            );
    not                                not0        (pgood_out        , pgood_out            );
    buf                                buf1        (VNB              , pgood_out            );

endmodule