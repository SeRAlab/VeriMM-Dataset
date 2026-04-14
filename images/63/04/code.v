module top_module(
    A,
    B,
    C,
    D,
    S0,
    S1,
    Y
);// Module ports
    input  A;
    input  B;
    input  C;
    input  D;
    input  S0;
    input  S1;
    output Y;

    // Local signals
    wire not_S0;
    wire not_S1;
    wire and0_out;
    wire and1_out;
    wire and2_out;
    wire and3_out;
    wire or0_out;
    wire or1_out;

    //  Name   Output      Other arguments
    not not0 (not_S0     , S0           );
    not not1 (not_S1     , S1           );
    and and0 (and0_out   , A, not_S0    );
    and and1 (and1_out   , B, S0        );
    and and2 (and2_out   , C, not_S1    );
    and and3 (and3_out   , D, S1        );
    or  or0  (or0_out    , and0_out, and1_out);
    or  or1  (or1_out    , and2_out, and3_out);
    or  or2  (Y          , or0_out, or1_out);

endmodule