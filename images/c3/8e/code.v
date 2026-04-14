module logic_gate (
    input A,
    input B,
    input C,
    output Y
);

    // Local signals
    wire and0_out;
    wire not0_out;
    wire not1_out;
    wire and1_out;
    wire or0_out;

    //  Name    Output      Other arguments
    and and0   (and0_out  , A, B    );
    not not0   (not0_out  , B      );
    not not1   (not1_out  , not0_out);
    and and1   (and1_out  , not1_out, C);
    or  or0    (or0_out   , and0_out, and1_out);
    buf buf0   (Y         , or0_out );

endmodule