module decoder_3to8(
    input [2:0] in,     // 3-bit input.
    input en,           // Enable signal to activate the decoder.

    output [7:0] out    // 8-bit output.
);

reg [7:0] out_r;

//------------------------------------------------
// 3-to-8 Decoder logic
always @(*) begin
    if (en) begin
        case (in)
            3'b000: out_r = 8'b00000001;
            3'b001: out_r = 8'b00000010;
            3'b010: out_r = 8'b00000100;
            3'b011: out_r = 8'b00001000;
            3'b100: out_r = 8'b00010000;
            3'b101: out_r = 8'b00100000;
            3'b110: out_r = 8'b01000000;
            3'b111: out_r = 8'b10000000;
            default: out_r = 8'b00000000;
        endcase
    end else begin
        out_r = 8'b00000000;
    end
end

assign out = out_r;

endmodule