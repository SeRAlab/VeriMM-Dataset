module decoder_2to4(
    input en,         // Enable signal.
    input [1:0] a,    // 2-bit binary input.
    output [3:0] y    // 4-bit one-hot output.
);

reg [3:0] y_r;

// Decoder logic
always @(*) begin
    if (en) begin
        case (a)
            2'b00: y_r = 4'b0001;
            2'b01: y_r = 4'b0010;
            2'b10: y_r = 4'b0100;
            2'b11: y_r = 4'b1000;
            default: y_r = 4'b0000;
        endcase
    end else begin
        y_r = 4'b0000;
    end
end

assign y = y_r;

endmodule