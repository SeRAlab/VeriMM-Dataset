module nand4 (
    input a,
    input b,
    input c,
    input d,
    output y
);

    wire temp;

    assign temp = a & b & c & d;
    assign y = ~temp;

endmodule