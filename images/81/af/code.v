module top_module(
    input A,
    input B,
    input C,
    input D,
    input E,
    input F,
    input G,
    input H,
    output Y
);wire notA, notB, notC, notD, notE, notF, notG, notH;
wire and1, and2, and3, and4, and5, and6, and7, and8, or1;

not u_notA(A, notA);
not u_notB(B, notB);
not u_notC(C, notC);
not u_notD(D, notD);
not u_notE(E, notE);
not u_notF(F, notF);
not u_notG(G, notG);
not u_notH(H, notH);

and u_and1(notA, notB, notC, notD, notE, notF, notG, notH, and1);
and u_and2(A, notB, notC, notD, notE, notF, notG, notH, and2);
and u_and3(notA, B, notC, notD, notE, notF, notG, notH, and3);
and u_and4(notA, notB, C, notD, notE, notF, notG, notH, and4);
and u_and5(notA, notB, notC, D, notE, notF, notG, notH, and5);
and u_and6(notA, notB, notC, notD, E, notF, notG, notH, and6);
and u_and7(notA, notB, notC, notD, notE, F, notG, notH, and7);
and u_and8(notA, notB, notC, notD, notE, notF, G, notH, and8);

or u_or1(and1, and2, and3, and4, and5, and6, and7, and8, or1);

assign Y = or1;

endmodule