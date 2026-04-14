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
);wire and1_out, and2_out, and3_out, and4_out, and5_out, and6_out, and7_out, and8_out, or1_out, or2_out;

    and and1(and1_out, A, B);
    and and2(and2_out, and1_out, C);
    not not1(D_bar, D);
    not not2(E_bar, E);
    and and3(and3_out, D_bar, E_bar);
    or or1(or1_out, F, G);
    not not3(H_bar, H);
    and and4(and4_out, and3_out, or1_out);
    and and5(and5_out, H_bar, and4_out);
    not not4(Y_bar, and5_out);
    or or2(Y, Y_bar, 1'b0);

endmodule