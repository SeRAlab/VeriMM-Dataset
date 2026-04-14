module top_module(
    X ,
    A1,
    A2,
    B1,
    EN
);output X ;
    input  A1;
    input  A2;
    input  B1;
    input  EN;

    assign X = EN ? (A1 & A2 & B1) : 1'b0;

endmodule