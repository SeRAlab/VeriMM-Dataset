module top_module(O, CO, CI, DI, S, CIN);output O;
    output CO;
    input CI, DI, S, CIN;

    wire A, B, C, D;

    assign A = S & DI;
    assign B = ~S & CI;
    assign O = A | B;

    assign C = CI & S;
    assign D = DI & (CI | S);
    assign CO = C | D;

endmodule