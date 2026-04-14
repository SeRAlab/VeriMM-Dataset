module top_module(
    input [1:0] A,
    input [1:0] B,
    output X
);wire [1:0] diff = A - B;
    wire borrow = diff[1];

    assign X = ~borrow & diff[0];

endmodule