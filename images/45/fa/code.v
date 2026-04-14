module ParityGenerator32bit (
    input [31:0] data_in,
    output parity_out
);

    assign parity_out = ^data_in;

endmodule