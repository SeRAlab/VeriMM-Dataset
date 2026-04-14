module sky130_fd_sc_lp__o31a (
    X,
    A1,
    A2,
    A3,
    B1
);

    output X;
    input A1;
    input A2;
    input A3;
    input B1;

    wire X1;
    wire X2;
    wire X3;

    assign X1 = (A1 == 1 && A2 == 0) ? 1 : 0;
    assign X2 = (A1 == 0 && A2 == 1) ? 0 : 1;
    assign X3 = (A1 == A2) ? A3 : ~A3;

    assign X = (B1 == 1) ? ~X3 : (X1 | X2 | X3);

endmodule