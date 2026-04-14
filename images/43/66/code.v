module top_module(
    Y ,
    A1,
    A2,
    B1
);output Y ;
    input  A1;
    input  A2;
    input  B1;

    wire n1, n2, n3, n4, n5, n6, n7;

    not (n1, A1);
    not (n2, A2);
    not (n3, B1);

    and (n4, n1, n2);
    and (n5, n1, B1);
    and (n6, A2, n3);
    and (n7, n6, n3);

    or (Y, n4, n5, n7);

endmodule