module binary_to_gray_16bit(
    input [15:0] binary_in, // Binary input data with a data width of 16 bits.
    output [15:0] gray_out  // Gray code output data with a data width of 16 bits.
);

assign gray_out = binary_in ^ (binary_in >> 1);    // Gray code conversion.

endmodule