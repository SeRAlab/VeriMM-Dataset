module decoder_3to8(
    input en,         // Enable signal.
    input [2:0] a,    // 3-bit binary input.
    output [7:0] y    // 8-bit one-hot output.
);

reg [7:0] y_r;

// Decoder logic
always @(*) begin
    if (en) begin
        case (a)
            3'b000: y_r = 8'b00000001;
            3'b001: y_r = 8'b00000010;
            3'b010: y_r = 8'b00000100;
            3'b011: y_r = 8'b00001000;
            3'b100: y_r = 8'b00010000;
            3'b101: y_r = 8'b00100000;
            3'b110: y_r = 8'b01000000;
            3'b111: y_r = 8'b10000000;
            default: y_r = 8'b00000000;
        endcase
    end else begin
        y_r = 8'b00000000;
    end
end

assign y = y_r;

endmodule