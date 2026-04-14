module top_module(
    output Y,
    input A
);wire not_A;
    assign not_A = ~A;

    assign Y = not_A & 1'b1;

endmodule