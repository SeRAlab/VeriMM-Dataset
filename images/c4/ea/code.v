module full_adder (
    input A,
    input B,
    input CI,
    output SUM,
    output COUT
);

    wire xor1_out;
    wire xor2_out;
    wire and1_out;
    wire and2_out;
    wire or1_out;

    xor xor1(xor1_out, A, B);
    xor xor2(SUM, xor1_out, CI);
    and and1(and1_out, A, B);
    and and2(and2_out, xor1_out, CI);
    or or1(or1_out, and1_out, and2_out);
    assign COUT = or1_out;

endmodule