module top_module(
    X,
    A1,
    A2,
    A3,
    B1,
    B2
);// Module ports
    output X ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;
    input  B2;

    // Local signals
    wire and_out;
    wire or_out;
    wire xor_out;

    //  Name  Output      Other arguments
    and and_gate (and_out, A1, A2, A3);
    or or_gate (or_out, B1, B2);
    xor xor_gate (xor_out, and_out, or_out);
    buf buf0 (X, xor_out);

endmodule