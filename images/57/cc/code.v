module top_module(
    Y ,
    A1,
    A2,
    B1,
    C1
);output Y ;
    input  A1;
    input  A2;
    input  B1;
    input  C1;

    // Intermediate wires
    wire w1, w2, w3;

    // AND gates
    and gate1(w1, A1, A2);
    and gate2(w2, B1, C1);
    and gate3(w3, w1, w2);
    assign Y = w3;

endmodule