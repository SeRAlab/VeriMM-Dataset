module top_module(
    X,
    A1,
    A2,
    B1,
    B2,
    C1
);// Module ports
    output X;
    input A1;
    input A2;
    input B1;
    input B2;
    input C1;

    // Local signals
    wire and0_out;
    wire and1_out;
    wire or0_out_X;

    // Name Output Other arguments
    and and0 (and0_out, A1, !B1);
    and and1 (and1_out, A2, !B2);
    or or0 (or0_out_X, and0_out, and1_out, C1);
    buf buf0 (X, or0_out_X);

endmodule