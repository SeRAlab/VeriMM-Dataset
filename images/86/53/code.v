module top_module(
    input a,
    input b,
    output y
);assign y = ~(a & b); // NAND operation
endmodule