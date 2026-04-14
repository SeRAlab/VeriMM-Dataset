module top_module(
    VPWR,
    VGND,
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    B2
);// Module ports
    input  VPWR;
    input  VGND;
    output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  B2  ;

    // Local signals
    wire    and0_out_Y         ;
    wire    and1_out_Y         ;
    wire    and2_out_Y         ;
    wire    and3_out_Y         ;
    wire    or0_out_Y          ;
    wire    or1_out_Y          ;
    wire    not0_out_A1        ;
    wire    not1_out_A2        ;
    wire    not2_out_B1        ;
    wire    not3_out_B2        ;
    wire    buf0_out_Y         ;

    //                           Name          Output              Other arguments
    and                          and0         (and0_out_Y        , A1, B1              );
    and                          and1         (and1_out_Y        , A1, B2              );
    and                          and2         (and2_out_Y        , A2, B1              );
    and                          and3         (and3_out_Y        , A2, B2              );
    or                           or0          (or0_out_Y         , and0_out_Y, and1_out_Y);
    or                           or1          (or1_out_Y         , and2_out_Y, and3_out_Y);
    not                          not0         (not0_out_A1       , A1                  );
    not                          not1         (not1_out_A2       , A2                  );
    not                          not2         (not2_out_B1       , B1                  );
    not                          not3         (not3_out_B2       , B2                  );
    or                           or2          (buf0_out_Y        , not0_out_A1, not1_out_A2, not2_out_B1, not3_out_B2);
    buf                          buf0         (Y                 , buf0_out_Y          );

endmodule