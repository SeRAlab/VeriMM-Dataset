module mux4to1 (
    input [3:0] in,
    input [1:0] sel,
    output out
);

    wire sel1_not, sel0_not;
    assign sel1_not = ~sel[1];
    assign sel0_not = ~sel[0];

    wire w0, w1, w2, w3;
    assign w0 = in[0] & sel0_not & sel1_not;
    assign w1 = in[1] & sel0_not & sel[1];
    assign w2 = in[2] & sel[0] & sel1_not;
    assign w3 = in[3] & sel[0] & sel[1];

    assign out = w0 | w1 | w2 | w3;

endmodule