module top_module (
    input [3:0] a,
    input [3:0] b,
    output lt,
    output eq,
    output gt
);

    assign lt = a < b;
    assign eq = a == b;
    assign gt = a > b;

endmodule