module mux_4to2 (
    X,
    A0,
    A1,
    A2,
    A3,
    S0,
    S1,
    EN
);

    output X;
    input A0;
    input A1;
    input A2;
    input A3;
    input S0;
    input S1;
    input EN;

    wire X0, X1;

    assign X0 = (S0 & S1) ? A3 : (S0 ? A2 : (S1 ? A1 : A0));
    assign X1 = (EN == 1'b0) ? X0 : 1'b0;
    assign X = X1;

endmodule