module decoder_5to32 (
    input [4:0] in,
    output reg [31:0] out
);

    // Decoder logic
    always @(*) begin
        out = 32'b00000000000000000000000000000000;
        out[in] = 1'b1;
    end

endmodule