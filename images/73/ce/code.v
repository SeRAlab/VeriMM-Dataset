module top_module (
    input wire u,
    input wire v,
    output wire f
);

    assign f = ~(u | v);

endmodule