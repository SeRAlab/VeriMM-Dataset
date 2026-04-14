module top_module(
    X   ,
    A1_N,
    A2_N,
    B1  ,
    B2
);// Module ports
    output X   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;

    // Local signals
    wire and0_out ;
    wire nor0_out ;
    wire nor1_out ;
    wire nor2_out ;
    wire buf0_out ;
    wire buf1_out ;
    wire buf2_out ;
    wire buf3_out ;
    wire buf4_out ;
    wire buf5_out ;
    wire buf6_out ;
    wire buf7_out ;
    wire buf8_out ;
    wire buf9_out ;
    wire buf10_out;
    wire buf11_out;

    //  Name  Output     Other arguments
    and and0 (and0_out , B1, B2            );
    nor nor0 (nor0_out , A1_N, A2_N        );
    nor nor1 (nor1_out , nor0_out          );
    nor nor2 (nor2_out , and0_out, nor1_out);
    buf buf0 (buf0_out , A1_N              );
    buf buf1 (buf1_out , A2_N              );
    buf buf2 (buf2_out , B1                );
    buf buf3 (buf3_out , B2                );
    buf buf4 (buf4_out , nor2_out          );
    buf buf5 (buf5_out , and0_out          );
    buf buf6 (buf6_out , nor1_out          );
    buf buf7 (buf7_out , nor0_out          );
    buf buf8 (buf8_out , buf1_out          );
    buf buf9 (buf9_out , buf2_out          );
    buf buf10(buf10_out, buf3_out          );
    buf buf11(buf11_out, buf0_out          );
    buf buf12(X        , buf4_out          );

endmodule