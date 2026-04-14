module top_module(
    input A, B, C, D,
    input S0, S1,
    output X
);wire not_S0, not_S1;
    wire and0, and1, and2, and3;
    wire or0, or1;

    not u_not_S0(not_S0, S0);
    not u_not_S1(not_S1, S1);

    and u_and0(and0, A, not_S0, not_S1);
    and u_and1(and1, B, not_S0, S1);
    and u_and2(and2, C, S0, not_S1);
    and u_and3(and3, D, S0, S1);

    or u_or0(or0, and0, and1);
    or u_or1(or1, and2, and3);

    or u_or2(X, or0, or1);

endmodule