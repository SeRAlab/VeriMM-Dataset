module decoder_7to128 (
    input [6:0] in,
    output reg [127:0] out
);

    // Decoder logic
    always @(*) begin
        out = 128'b0;
        out[in] = 1'b1;
    end

endmodule