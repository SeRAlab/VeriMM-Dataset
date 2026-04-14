module top_module(
    A,
    SLEEP,
    X
);// Module ports
    input A;
    input SLEEP;
    output X;

    // Local signals
    wire not0_out  ;
    wire and0_out_X;

    //  Name  Output      Other arguments
    not not0 (not0_out  , SLEEP          );
    and and0 (and0_out_X, not0_out, A    );
    buf buf0 (X         , and0_out_X     );

endmodule