module top_module(
    X,
    A,
    B,
    C,
    D
);// Module ports
    output X;
    input  A;
    input  B;
    input  C;
    input  D;

    // Local signals
    wire and0_out_X;
    wire and1_out_X;

    //  Name  Output      Other arguments
    and and0 (and0_out_X, C, A, B        );
    and and1 (and1_out_X, D, and0_out_X  );
    buf buf0 (X         , and1_out_X     );

endmodule