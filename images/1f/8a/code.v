module huffman_encoder (
    input [3:0] char_in,
    output reg [11:0] encoded_out
);

always @(*) begin
    case (char_in)
        4'b0000: encoded_out = 12'b00_000000000; // A
        4'b0001: encoded_out = 12'b01_000000000; // B
        4'b0010: encoded_out = 12'b10_000000000; // C
        4'b0011: encoded_out = 12'b110_00000000; // D
        4'b0100: encoded_out = 12'b111_00000000; // E
        default: encoded_out = 12'b000000000000; // Default case for invalid input
    endcase
end

endmodule