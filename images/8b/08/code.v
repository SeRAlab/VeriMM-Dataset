module binary_to_gray_8bit(
    input [7:0] binary_in, // Binary input data with a data width of 8 bits.
    output [7:0] gray_out  // Gray code output data with a data width of 8 bits.
);

assign gray_out = binary_in ^ (binary_in >> 1);    // Gray code conversion.

endmodule