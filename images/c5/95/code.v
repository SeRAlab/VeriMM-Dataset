module my_xor(
    out,
    in1,
    in2
);

    output out;
    input in1, in2;

    wire w1, w2, w3, w4;

    assign w1 = ~in1;
    assign w2 = ~in2;
    assign w3 = in1 & w2;
    assign w4 = w1 & in2;
    assign out = w3 | w4;

endmodule