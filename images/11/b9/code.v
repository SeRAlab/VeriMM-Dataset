module huffman_encoder (
    input [3:0] char_in,
    output reg [2:0] huffman_code
);
    always @(*) begin
        case (char_in)
            4'b0000: huffman_code = 3'b00; // A
            4'b0001: huffman_code = 3'b01; // B
            4'b0010: huffman_code = 3'b10; // C
            4'b0011: huffman_code = 3'b11; // D
            default: huffman_code = 3'b111; // Invalid
        endcase
    end
endmodule