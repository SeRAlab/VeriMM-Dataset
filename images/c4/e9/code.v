module sky130_fd_sc_hd__full_adder (
    A,
    B,
    Cin,
    Cout,
    S
);

    // Module ports
    input A, B, Cin;
    output Cout, S;

    // Internal signals
    wire X1, X2, X3;
    wire Y1, Y2;

    //  Name  Output  Other arguments
    xor  xor0 (X1, A, B);
    xor  xor1 (X2, X1, Cin);
    and  and0 (X3, X1, Cin);
    and  and1 (Y1, A, B);
    and  and2 (Y2, X1, Cin);
    or   or0  (Cout, X3, Y1, Y2);
    assign S = X2;

endmodule