module top_module (
    input wire m,
    input wire n,
    output wire o
);

    assign o = ~(m & n);

endmodule