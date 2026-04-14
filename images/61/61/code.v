module top_module(
    // Inputs
    input [1:0] a,
    input [1:0] b,
    input cin,

    // Outputs
    output [1:0] sum,
    output cout
);wire c1, c2;

    assign {sum[0], c1} = a[0] + b[0] + cin;
    assign {sum[1], c2} = a[1] + b[1] + c1;

    assign cout = c2;

endmodule