module top_module(
    input [1:0] a,
    input [1:0] b,
    output gt
);

    assign gt = (a > b);  // Output high if a is greater than b

endmodule