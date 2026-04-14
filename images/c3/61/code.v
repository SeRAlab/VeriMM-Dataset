module my_mux2 (
    X   ,
    A0  ,
    A1  ,
    S   
);

    output X   ;
    input  A0  ;
    input  A1  ;
    input  S   ;

    wire notS;
    wire and1;
    wire and2;

    not #(1) inv1(notS, S);
    and #(1) gate1(and1, A0, notS);
    and #(1) gate2(and2, A1, S);
    or #(1) gate3(X, and1, and2);

endmodule