module decoder_2to4(
    input enable,           // Enable signal for the decoder.
    input [1:0] binary_in,  // Binary input data with a data width of 2 bits.
    output [3:0] one_hot_out // One-hot encoded output data with a data width of 4 bits.
);

reg [3:0] decoded;         // Decoded output register.

always @(*)
    if (enable)
        case (binary_in)
            2'b00: decoded = 4'b0001;
            2'b01: decoded = 4'b0010;
            2'b10: decoded = 4'b0100;
            2'b11: decoded = 4'b1000;
            default: decoded = 4'b0000;
        endcase
    else
        decoded = 4'b0000;                        // All outputs are zero if enable is not active.

assign one_hot_out = decoded;                    // Output decoded value.

endmodule