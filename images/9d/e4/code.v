module top_module(
    A,
    B,
    C_in,
    S,
    C_out
);// Module ports
    input [1:0] A;
    input [1:0] B;
    input C_in;
    output [1:0] S;
    output C_out;

    // Local signals
    wire carry_out_1;
    wire carry_out_2;

    //  Name      Output          Other arguments
    xor  xor0_1 (S[0]           , A[0], B[0]           );
    xor  xor0_2 (S[1]           , A[1], B[1]           );
    and  and0_1 (carry_out_1    , A[0], B[0]           );
    and  and0_2 (carry_out_2    , A[1], B[1]           );
    or   or0_1  (C_out          , carry_out_1, C_in   );
    or   or0_2  (C_out          , carry_out_2, C_out  );

endmodule