module top_module (
    input signed [3:0] k,
    input signed [3:0] l,
    output signed [3:0] m
);

    // Perform addition
    assign m = k + l;

endmodule