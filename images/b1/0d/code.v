module top_module(
    X,
    A,
    B
);// Module ports
    output X;
    input  A;
    input  B;

    // Local signals
    wire not0_out_A;
    wire not0_out_B;
    wire and0_out_AB;
    wire not1_out_AB;

    //  Name  Output         Other arguments
    not not0 (not0_out_A   , A        );
    not not1 (not0_out_B   , B        );
    and and0 (and0_out_AB  , not0_out_A, not0_out_B);
    not not2 (not1_out_AB  , and0_out_AB);
    buf buf0 (X            , not1_out_AB);

endmodule