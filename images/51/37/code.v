module top_module(
    input a,
    input b,
    input c,
    input d,
    output y
);wire all_ones;
    wire all_zeros;

    assign all_ones = (a & b & c & d);
    assign all_zeros = (!a & !b & !c & !d);

    assign y = (all_ones | all_zeros);

endmodule