module decoder_8to256 (
    input [7:0] in,
    output reg [255:0] out
);

    // Decoder logic
    always @(*) begin
        out = 256'b0;
        out[in] = 1'b1;
    end

endmodule