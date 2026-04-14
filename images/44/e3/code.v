module top_module (
    input wire m,
    input wire n,
    output wire s
);

    assign s = m & n;

endmodule