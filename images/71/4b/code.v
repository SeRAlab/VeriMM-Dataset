module top_module(
    X ,
    A1,
    A2,
    B1
);output X ;
    input  A1;
    input  A2;
    input  B1;

    wire C1;
    wire C2;

    assign C1 = (A1 & A2) ? ~B1 : (A1 | A2);
    assign C2 = (A1 & A2) ? C1 : B1;
    assign X = (A1 & A2) ? C2 : (A1 & ~A2) ? ~B1 : (A1 | A2) ? B1 : 0;

endmodule