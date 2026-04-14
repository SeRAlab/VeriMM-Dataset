module top_module(
    input A,
    output X
);// Local signals
    wire buf0_out_X;
    wire buf1_out_X;

    // Buffers
    buf buf0(buf0_out_X, A);
    buf buf1(buf1_out_X, buf0_out_X);

    // Delay
    assign #5 X = buf1_out_X;

endmodule