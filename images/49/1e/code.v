module top_module(
    input a,
    input b,
    input c,
    input d,
    input e,
    output f
);assign f = (a + b + c + d + e) >= 3 ? 1 : 0;

endmodule