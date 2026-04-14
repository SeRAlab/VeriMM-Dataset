module parity_generator (
    input [3:0] a,
    output parity
);

    assign parity = ~(a[3] ^ a[2] ^ a[1] ^ a[0]);

endmodule