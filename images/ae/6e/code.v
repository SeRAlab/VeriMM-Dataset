module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output eq,
    output lt,
    output gt
);assign eq = (A == B);
    assign lt = (A < B);
    assign gt = (A > B);

endmodule