module top_module(
    input A,
    input B,
    input C,
    output X
);wire AB;
    wire AC;
    wire BC;

    and AB_and (AB, A, B);
    and AC_and (AC, A, C);
    and BC_and (BC, B, C);

    or or_gate (X, AB, AC, BC);

endmodule