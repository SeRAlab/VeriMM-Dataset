module decoder_2to4(
    input [1:0] in,     // 2-bit binary input.
    input en,           // Enable signal to activate the decoder.

    output [3:0] out    // 4-bit one-hot output.
);

reg [3:0] out_r;

//------------------------------------------------
// Decoder logic
always @(*) begin
    if (en) begin
        case (in)
            2'b00: out_r = 4'b0001;
            2'b01: out_r = 4'b0010;
            2'b10: out_r = 4'b0100;
            2'b11: out_r = 4'b1000;
            default: out_r = 4'b0000;
        endcase
    end else begin
        out_r = 4'b0000;
    end
end

assign out = out_r;

endmodule