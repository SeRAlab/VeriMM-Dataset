module binary_to_gray_4bit(
    input [3:0] bin_in,     // 4-bit binary input.
    output [3:0] gray_out   // 4-bit Gray code output.
);

assign gray_out[3] = bin_in[3];                    // MSB remains the same.
assign gray_out[2] = bin_in[3] ^ bin_in[2];        // XOR previous bit with current bit.
assign gray_out[1] = bin_in[2] ^ bin_in[1];        // XOR previous bit with current bit.
assign gray_out[0] = bin_in[1] ^ bin_in[0];        // XOR previous bit with current bit.

endmodule