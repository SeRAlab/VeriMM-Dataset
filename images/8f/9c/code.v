module binary_to_gray_4bit(
    input [3:0] binary_in, // Binary input data with a data width of 4 bits.
    output [3:0] gray_out  // Gray code output data with a data width of 4 bits.
);

assign gray_out = binary_in ^ (binary_in >> 1);    // Gray code conversion.

endmodule