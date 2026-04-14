module huffman_encoder(
    input [1:0] char, // 00 for 'A', 01 for 'B', 10 for 'C', 11 for invalid
    output reg [1:0] encoded
);
    always @(*) begin
        case (char)
            2'b00: encoded = 2'b00; // A
            2'b01: encoded = 2'b01; // B
            2'b10: encoded = 2'b10; // C
            default: encoded = 2'b11; // Invalid
        endcase
    end
endmodule