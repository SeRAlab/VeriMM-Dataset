module top_module(
    X,
    A
);// Module ports
    output X;
    input  A;

    // Local signals
    wire buf0_out_X;
    wire buf1_out_X;
    wire buf2_out_X;
    wire buf3_out_X;

    //  Name  Output      Other arguments
    buf buf0 (buf0_out_X, A              );
    buf buf1 (buf1_out_X, buf0_out_X     );
    buf buf2 (buf2_out_X, buf1_out_X     );
    buf buf3 (X         , buf2_out_X     );

endmodule