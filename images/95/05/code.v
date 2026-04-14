module top_module (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire lt,
    output wire eq,
    output wire gt
);

    assign lt = a < b;
    assign eq = a == b;
    assign gt = a > b;

endmodule