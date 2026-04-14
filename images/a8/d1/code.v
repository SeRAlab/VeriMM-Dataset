module top_module(
    input [3:0] in_a,
    input [3:0] in_b,
    output eq,
    output gt,
    output lt
);assign eq = (in_a == in_b);
    assign gt = (in_a > in_b);
    assign lt = (in_a < in_b);

endmodule