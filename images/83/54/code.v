module decoder_4to16(
    input [3:0] in,        // 4-bit input signal.
    output reg [15:0] out  // 16-bit output signal.
);

always @(*) begin
    out = 16'b0;           // Default to all bits low.
    out[in] = 1'b1;        // Set the bit corresponding to the input high.
end

endmodule