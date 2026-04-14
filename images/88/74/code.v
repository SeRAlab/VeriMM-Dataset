module binary_to_gray_12bit(
    input [11:0] binary_in, // Binary input data with a data width of 12 bits.
    output [11:0] gray_out  // Gray code output data with a data width of 12 bits.
);

assign gray_out = binary_in ^ (binary_in >> 1);    // Gray code conversion.

endmodule