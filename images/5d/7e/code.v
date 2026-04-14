module top_module(
    input [3:0] a,
    input [3:0] b,
    input eq,
    output gt,
    output lt,
    output eq_out
);// Check for equality
    assign eq_out = (a == b);

    // Check for greater than
    assign gt = (a > b);

    // Check for less than
    assign lt = (a < b);

endmodule