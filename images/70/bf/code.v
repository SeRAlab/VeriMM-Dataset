module decoder_11to2048 (
    input [10:0] in,
    output reg [2047:0] out
);

    // Decoder logic
    always @(*) begin
        out = 2048'b0;
        out[in] = 1'b1;
    end

endmodule