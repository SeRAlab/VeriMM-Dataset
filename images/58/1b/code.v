module top_module(
    X ,
    A1,
    A2,
    A3,
    B1,
    B2
);output X ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;
    input  B2;

    assign X = (A1 & A2 & ~A3) ? 0 :
               (~A1 & ~A2) ? 1 :
               (A1 & ~A2) ? B1 :
               (~A1 & A2) ? B2 :
               1'b1;

endmodule