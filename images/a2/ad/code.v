module top_module(
    input [3:0] binary,
    output [4:0] bcd
);

    // Convert binary to BCD (Binary Coded Decimal)
    assign bcd = (binary >= 4'd10) ? (binary + 5'd6) : binary;

endmodule