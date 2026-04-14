module top_module(
    input a,
    input b,
    input c,
    input d,
    output y
);wire temp;

    assign temp = a & b & c & d;
    assign y = ~temp;

endmodule