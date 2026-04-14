module top_module(
    Y,
    A,
    B,
    C,
    D
);// Module ports
    output Y;
    input A;
    input B;
    input C;
    input D;

    // Local signals
    wire not0_out;
    wire not1_out;
    wire and0_out;
    wire and1_out;
    wire or0_out;

    //   Name   Output       Other arguments
    not  not0  (not0_out   , A             );
    not  not1  (not1_out   , B             );
    and  and0  (and0_out   , A, B          );
    and  and1  (and1_out   , C, D          );
    or   or0   (or0_out    , and0_out, and1_out);
    not  not2  (Y          , or0_out       );

endmodule