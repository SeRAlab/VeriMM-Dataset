module top_module(
    output zn,
    input a,
    input b
);assign zn = ~(a & b);
endmodule