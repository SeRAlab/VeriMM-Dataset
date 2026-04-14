module my_xor3 (
    input A,
    input B,
    input C,
    output X
);

    wire AB, BC, AC;
    
    and AB_gate (AB, A, B);
    and BC_gate (BC, B, C);
    and AC_gate (AC, A, C);
    
    or AB_BC_gate (X, AB, BC);
    or X_AC_gate (X, X, AC);
    
    not X_gate (X, X);

endmodule