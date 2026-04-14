module parity_checker (
    input [7:0] data,
    input parity,
    output error
);

    // Parity check
    assign error = ^data ^ parity;

endmodule