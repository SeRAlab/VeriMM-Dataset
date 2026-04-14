module top_module(
    input  A1,
    input  A2,
    input  B1,
    input  C1,
    input  D1,
    output X
);wire condition1 = (A1 == 1) && (A2 == 0);
    wire condition2 = (B1 == 1) && (C1 == 0);
    wire condition3 = (D1 == 1);

    assign X = (condition1 || condition2) ? 1 :
               (condition3) ? 0 :
               0;

endmodule