module decoder_9to512 (
    input [8:0] in,
    output reg [511:0] out
);

    // Decoder logic
    always @(*) begin
        out = 512'b0;
        out[in] = 1'b1;
    end

endmodule