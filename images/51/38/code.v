module top_module(
    input a, b, cin,
    output cout, sum
);wire w1, w2, w3;

    xor(sum, a, b);
    xor(cout, sum, cin);
    and(w1, a, b);
    and(w2, a, cin);
    and(w3, b, cin);
    or(cout, cout, w1);
    or(sum, sum, w2);
    or(sum, sum, w3);

endmodule