module top_module(
    input  [17:0] n,
    output [17:0] n_pow_5
);assign n_pow_5 = n * n * n * n * n;endmodule