module top_module(
    input a, b, cin,
    output sum, cout
);wire s1, c1, s2, c2;

    // Stage 1
    xor x1(s1, a, b);
    and a1(c1, a, b);
    xor x2(s2, s1, cin);
    and a2(c2, s1, cin);

    // Stage 2
    xor sum_out(sum, s2, c1);
    and a3(cout, s2, c1);
    // The intermediate signal s2 is already defined, no need to xor it again
    // It has already been defined to compute the sum based on previous and gates.

endmodule