module top_module(
    Y,
    A,
    B
);output Y;
    input  A;
    input  B;

    // Assign the output Y to the XNOR of inputs A and B
    assign Y = ~(A ^ B);

endmodule