module top_module (
    input wire m,
    input wire n,
    input wire o,
    output wire p
);

    assign p = ~(m & n & o);

endmodule