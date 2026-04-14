module parity_generator (
    input [7:0] data,
    output parity
);

    // Parity generation
    assign parity = ^data;

endmodule