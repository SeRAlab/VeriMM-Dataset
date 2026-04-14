module xnor3 (
    input  A   ,
    input  B   ,
    input  C   ,
    output X   ,

    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);

wire w1, w2, w3, w4, w5;

and and1(w1, A, B);
and and2(w2, A, C);
and and3(w3, B, C);
or or1(w4, w1, w2);
or or2(w5, w4, w3);
not not1(X, w5);

endmodule