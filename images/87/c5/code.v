module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    input addSub,
    output signed [3:0] result
);wire add;
    assign add = ~addSub;

    assign result = add ? A + B : A - B;

endmodule