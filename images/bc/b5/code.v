module binary_to_gray_10bit(
    input [9:0] binary_in, // Binary input data with a data width of 10 bits.
    output [9:0] gray_out  // Gray code output data with a data width of 10 bits.
);

assign gray_out = binary_in ^ (binary_in >> 1);    // Gray code conversion.

endmodule