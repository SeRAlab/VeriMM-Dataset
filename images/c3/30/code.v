module sky130_fd_sc_ms__a221o (
    X ,
    A1,
    A2,
    B1,
    B2,
    C1
);

    output X ;
    input  A1;
    input  A2;
    input  B1;
    input  B2;
    input  C1;

    assign X = (A1 & ~A2) ? B1 :
               (~A1 & A2) ? B2 :
               (A1 & A2) ? C1 : 1'b0;

endmodule