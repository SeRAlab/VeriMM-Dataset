module decoder_6to64 (
    input [5:0] in,
    output reg [63:0] out
);

    // Decoder logic
    always @(*) begin
        out = 64'b0000000000000000000000000000000000000000000000000000000000000000;
        out[in] = 1'b1;
    end

endmodule